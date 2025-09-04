import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/controller/my_account_controller.dart';

import '../../../core/utils/check_strikes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initApp();
  }

  Future<void> initApp() async {
    try {
      // 1) Get user data
      await Get.put(MyAccountController()).getUserData();

      // 2) Check strikes → if safe, go home
      final isSafe = await checkStrikes();

      if (isSafe) {
        Get.offAllNamed(Routes.homeScreen);
      }
    } catch (e) {
      rethrow;
    }
  }
}
