import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../service/my_service.dart';
import '../service/shared_prefrences_keys.dart';

Future<http.Response?> sendAuthenticatedRequest({
  required String url,
  required String method,
  Map<String, String>? headers,
  dynamic body,
}) async {
  final myService = Get.find<MyService>();
  final token = myService.getStringData(SharedPrefrencesKeys.accessToken);

  final defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    ...?headers,
  };

  http.Response response;

  try {
    if (method == 'GET') {
      response = await http.get(Uri.parse(url), headers: defaultHeaders);
    } else {
      response = await http.post(Uri.parse(url),
          headers: defaultHeaders, body: jsonEncode(body));
    }

    if (response.statusCode == 401) {
      // Token expired
      bool refreshed = await myService.refreshAccessToken();
      if (refreshed) {
        return await sendAuthenticatedRequest(
          url: url,
          method: method,
          headers: headers,
          body: body,
        );
      } else {
        // Logout
        await myService.storeBoolData(SharedPrefrencesKeys.isLoginKey, false);
        return null;
      }
    }

    return response;
  } catch (e) {
    return null;
  }
}
