import 'dart:async';

class ConstData {
  static bool isLogin = false;
  static String? token = "";
  static Future<void> updateToken() async {}
  static Future<void> startTokenUpdater() async {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      updateToken();
    });
  }
}
