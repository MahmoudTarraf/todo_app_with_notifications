import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_with_notifications/core/service/app_link.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import '../const_data/const_data.dart';
import 'shared_prefrences_keys.dart';

class MyService extends GetxService {
  late SharedPreferences _prefs;

  Future<MyService> init() async {
    _prefs = await SharedPreferences.getInstance();
    String? token = getStringData(SharedPrefrencesKeys.accessToken);
    if (token != null) {
      ConstData.token = token;
    }
    return this;
  }

  Future<void> storeStringData(String key, String val) async {
    await _prefs.setString(key, val);
  }

  bool? getBoolData(String key) {
    return _prefs.getBool(key);
  }

  int? getIntData(String key) {
    return _prefs.getInt(key);
  }

  Future<void> storeBoolData(String key, bool val) async {
    await _prefs.setBool(key, val);
  }

  Future<void> storeIntData(String key, int val) async {
    await _prefs.setInt(key, val);
  }

  String? getStringData(String key) {
    return _prefs.getString(key);
  }

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> setConstantData() async {
    ConstData.token = getStringData(SharedPrefrencesKeys.accessToken);
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = getStringData(SharedPrefrencesKeys.refreshToken);
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse(AppLink.refreshToken),
        headers: AppLink().getHeader(),
        body: jsonEncode({'token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final newAccessToken = body['accessToken'];

        if (newAccessToken != null) {
          await storeStringData(
              SharedPrefrencesKeys.accessToken, newAccessToken);
          await setConstantData(); // updates ConstData.token
          return true;
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // 🔐 Refresh token is invalid or expired — must log in again
        await clearAllUserData(); // Remove all tokens
        Get.offAllNamed(Routes.loginScreen); // Or use your login route
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAllUserData() async {
    await removeData(SharedPrefrencesKeys.accessToken);
    await removeData(SharedPrefrencesKeys.refreshToken);
    await removeData(SharedPrefrencesKeys.isLoginKey);
    await _prefs.clear();
    // Clear other user-related keys if needed
  }
}

Future<void> initialService() async {
  await Get.putAsync(() => MyService().init());
}
