import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_animations.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/data/local/database_service.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/widgets/warning_strikes_screen.dart';

import '../class/crud.dart';
import '../const_data/app_colors.dart';
import '../service/app_link.dart';
import '../service/messages.dart';
import '../service/my_service.dart';
import '../service/network_manager.dart';

Future<void> clearUserData() async {
  try {
    final myService = Get.find<MyService>();
    await myService.clearAllUserData();
    final DatabaseService databaseService = DatabaseService.instance;

    await databaseService.clearUserData();
  } catch (e) {
    rethrow;
  }
}

Future<bool> checkStrikes() async {
  try {
    if (await NetworkManager().isOnline()) {
      final result = await Crud().postData(
        AppLink.checkStrikes,
        {},
        AppLink().getHeaderToken(),
        false,
      );

      return await result.fold(
        (error) {
          Messages.getSnackMessage(
            "Error".tr,
            error.message ?? "Something went wrong".tr,
            ColorsManager.primary,
          );
          Get.offAllNamed(Routes.signupScreen);
          return false; // default safe
        },
        (responseBody) async {
          final message = responseBody['message'] ?? '';
          final strikes = responseBody['strikes'] ?? 0;

          if (strikes == 0) {
            return true; // safe
          }

          if (message.contains('deleted')) {
            await clearUserData();
            Get.offAll(
              () => WarningStrikesScreen(
                animationName: AppAnimations.accountDeleted,
                taskStrikes: 3,
              ),
            );
            return false;
          } else {
            Get.offAll(
              () => WarningStrikesScreen(
                animationName: AppAnimations.warning,
                taskStrikes: strikes,
              ),
            );
            return false;
          }
        },
      );
    } else {
      Messages.getSnackMessage(
        'No internet!'.tr,
        'checkInternet'.tr,
        ColorsManager.primary,
      );
      return false;
    }
  } catch (e) {
    Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    return false;
  }
}
