import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/core/service/app_link.dart';
import 'package:todo_app_with_notifications/core/service/network_manager.dart';
import '../service/my_service.dart';
import '../service/shared_prefrences_keys.dart';

class Crud {
  Future<Either<RequestError, Map<String, dynamic>>> postData(
    String linkUrl,
    Map<String, dynamic> data,
    Map<String, String> headers,
    bool toSaveToken, {
    bool isFormData = false,
    String methodCall = "POST",
  }) async {
    try {
      if (await NetworkManager().isOnline()) {
        http.Response response = await _sendRequest(
          linkUrl,
          data,
          headers,
          methodCall,
          isFormData,
        );

        var responseBody = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (toSaveToken &&
              responseBody['accessToken'] != null &&
              responseBody['refreshToken'] != null) {
            final myService = Get.find<MyService>();
            await myService.storeStringData(
                SharedPrefrencesKeys.accessToken, responseBody['accessToken']);
            await myService.storeStringData(SharedPrefrencesKeys.refreshToken,
                responseBody['refreshToken']);
            await myService.setConstantData();
          }

          return Right(responseBody);
        } else if ((response.statusCode == 401 || response.statusCode == 403) &&
            !toSaveToken) {
          // Try refreshing token
          final myService = Get.find<MyService>();
          bool refreshed = await myService.refreshAccessToken();
          if (refreshed) {
            final myService = Get.find<MyService>();
            String? newToken =
                myService.getStringData(SharedPrefrencesKeys.accessToken);
            headers['Authorization'] = 'Bearer $newToken';

            final retryResponse = await _sendRequest(
              linkUrl,
              data,
              headers,
              methodCall,
              isFormData,
            );

            final retryBody = jsonDecode(retryResponse.body);

            if (retryResponse.statusCode == 200 ||
                retryResponse.statusCode == 201) {
              return Right(retryBody);
            } else {
              final rawMessage =
                  retryBody['message']?.toString() ?? 'An error occurred';
              return Left(RequestError(StatusRequest.authFailure,
                  message: rawMessage.tr));
            }
          } else {
            final rawMessage =
                responseBody['message']?.toString() ?? 'An error occurred';
            return Left(
              RequestError(StatusRequest.failure, message: rawMessage.tr),
            );
          }
        } else {
          final rawMessage =
              responseBody['message']?.toString() ?? 'An error occurred';
          return Left(
            RequestError(StatusRequest.failure, message: rawMessage.tr),
          );
        }
      } else {
        final errorMessage = "No network Connection.".tr;
        return Left(
          RequestError(StatusRequest.offlineFailure, message: errorMessage),
        );
      }
    } catch (e) {
      final errorMessage = cleanErrorMessage(e);
      return Left(
        RequestError(StatusRequest.serverFailure, message: errorMessage),
      );
    }
  }

  Future<Either<RequestError, dynamic>> getData(String linkUrl) async {
    final myService = Get.find<MyService>();

    try {
      if (await NetworkManager().isOnline()) {
        var response = await http.get(
          Uri.parse(linkUrl),
          headers: AppLink().getHeaderToken(),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          try {
            final decoded = jsonDecode(response.body);
            return Right(decoded);
          } catch (e) {
            final errorMessage = cleanErrorMessage(e);
            return Left(
              RequestError(StatusRequest.serverFailure, message: errorMessage),
            );
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          bool refreshed = await myService.refreshAccessToken();
          if (refreshed) {
            var retryRes = await http.get(
              Uri.parse(linkUrl),
              headers: AppLink().getHeaderToken(),
            );
            if (retryRes.statusCode == 200 || retryRes.statusCode == 201) {
              try {
                var retryBody = jsonDecode(retryRes.body);
                return Right(retryBody);
              } catch (e) {
                final errorMessage = cleanErrorMessage(e);
                return Left(
                  RequestError(StatusRequest.serverFailure,
                      message: errorMessage),
                );
              }
            } else {
              var retryBody = jsonDecode(retryRes.body);
              final rawMessage =
                  retryBody['message']?.toString() ?? 'An error occurred';
              return Left(
                RequestError(StatusRequest.authFailure, message: rawMessage.tr),
              );
            }
          } else {
            final errorMessage = "Not authenticated.".tr;
            return Left(
              RequestError(StatusRequest.authFailure, message: errorMessage),
            );
          }
        } else {
          try {
            var errorBody = jsonDecode(response.body);
            final rawMessage =
                errorBody['message']?.toString() ?? 'An error occurred';
            return Left(
              RequestError(StatusRequest.serverFailure, message: rawMessage.tr),
            );
          } catch (e) {
            final errorMessage = cleanErrorMessage(e);
            return Left(
              RequestError(StatusRequest.serverFailure, message: errorMessage),
            );
          }
        }
      } else {
        final errorMessage = "No Network Connection.".tr;
        return Left(
          RequestError(StatusRequest.offlineFailure, message: errorMessage),
        );
      }
    } catch (e) {
      final errorMessage = cleanErrorMessage(e);
      return Left(
        RequestError(StatusRequest.failure, message: errorMessage),
      );
    }
  }

  /// ✅ PUT method to update tasks
  Future<Either<RequestError, Map<String, dynamic>>> putData(
    String linkUrl,
    Map<String, dynamic> data,
    Map<String, String> headers,
  ) async {
    return await postData(
      linkUrl,
      data,
      headers,
      false,
      methodCall: "PUT",
    );
  }

  /// ✅ DELETE method to remove tasks
  Future<Either<RequestError, dynamic>> deleteData(
    String linkUrl,
    Map<String, String> headers,
  ) async {
    final myService = Get.find<MyService>();

    try {
      if (await NetworkManager().isOnline()) {
        var response = await http.delete(
          Uri.parse(linkUrl),
          headers: headers,
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          return Right("Deleted successfully".tr);
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          bool refreshed = await myService.refreshAccessToken();
          if (refreshed) {
            headers['Authorization'] =
                'Bearer ${myService.getStringData(SharedPrefrencesKeys.accessToken)}';
            var retryRes = await http.delete(
              Uri.parse(linkUrl),
              headers: headers,
            );

            if (retryRes.statusCode == 200 || retryRes.statusCode == 204) {
              return Right("Deleted successfully".tr);
            } else {
              final responseBody = jsonDecode(response.body);
              final rawMessage =
                  responseBody['message']?.toString() ?? 'An error occurred';
              return Left(
                RequestError(
                  StatusRequest.authFailure,
                  message: rawMessage.tr,
                ),
              );
            }
          } else {
            final responseBody = jsonDecode(response.body);
            final rawMessage =
                responseBody['message']?.toString() ?? 'An error occurred';
            return Left(
              RequestError(
                StatusRequest.authFailure,
                message: rawMessage.tr,
              ),
            );
          }
        } else {
          final responseBody = jsonDecode(response.body);
          final rawMessage =
              responseBody['message']?.toString() ?? 'An error occurred';
          return Left(
            RequestError(StatusRequest.serverFailure, message: rawMessage.tr),
          );
        }
      } else {
        final errorMessage = "No Network Connection.".tr;
        return Left(RequestError(StatusRequest.failure, message: errorMessage));
      }
    } catch (e) {
      final errorMessage = cleanErrorMessage(e);
      return Left(
        RequestError(StatusRequest.failure, message: errorMessage),
      );
    }
  }

  Future<http.Response> _sendRequest(
    String linkUrl,
    Map<String, dynamic> data,
    Map<String, String> headers,
    String methodCall,
    bool isFormData,
  ) async {
    Uri uri = Uri.parse(linkUrl);

    if (isFormData) {
      var request = http.MultipartRequest(methodCall, uri);

      // Add fields and files
      for (var entry in data.entries) {
        if (entry.value is File) {
          request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value.path));
        } else {
          request.fields[entry.key] = entry.value.toString();
        }
      }

      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    }

    // Handle JSON request
    if (methodCall == "POST") {
      return await http.post(uri, body: jsonEncode(data), headers: headers);
    } else if (methodCall == "PUT") {
      return await http.put(uri, body: jsonEncode(data), headers: headers);
    } else {
      throw Exception("${'Unsupported HTTP method:'.tr} $methodCall");
    }
  }

  /// ✅ Utility: clean and translate known error messages
  String cleanErrorMessage(Object e) {
    final raw = e.toString();

    if (raw.contains("Connection closed")) {
      return "connection_closed_error".tr;
    }
    if (raw.contains("SocketException")) {
      return "socket_error".tr; // no internet / server unreachable
    }
    if (raw.contains("TimeoutException") || raw.contains("timed out")) {
      return "timeout_error".tr; // request timed out
    }
    if (raw.contains("HandshakeException")) {
      return "ssl_error".tr; // SSL/TLS certificate issue
    }
    if (raw.contains("FormatException")) {
      return "format_error".tr; // invalid response / JSON parse
    }
    if (raw.contains("ClientException")) {
      return "client_error".tr; // generic client exception
    }

    // Remove dynamic URI part if exists
    final cleaned = raw.replaceAll(RegExp(r'uri=.*'), '').trim();

    return cleaned.tr;
  }
}
