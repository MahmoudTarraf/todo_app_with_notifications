import 'package:get/get.dart';

import '../../../core/class/crud.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/service/app_link.dart';
import '../../../core/service/messages.dart';
import '../../../core/service/my_service.dart';
import '../../../core/service/network_manager.dart';
import '../../../core/service/routes.dart';
import '../screen/otp_reset_screen.dart';

class PasswordController extends GetxController {
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isOldPasswordVisible = false;

  // Toggling password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void toggleOldPasswordVisibility() {
    isOldPasswordVisible = !isOldPasswordVisible;
    update();
  }

// 1. Change Password (user logged in)
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    if (currentPassword.isEmpty ||
        (currentPassword.length < 6) ||
        newPassword.isEmpty ||
        (newPassword.length < 6)) {
      Messages.getSnackMessage(
          "Follow These Rules:".tr, 'passRules'.tr, ColorsManager.primary);
      return;
    }
    try {
      isLoading = true;
      update();
      if (await NetworkManager().isOnline()) {
        final result = await Crud().postData(
          AppLink.changePassword,
          {"currentPassword": currentPassword, "newPassword": newPassword},
          AppLink().getHeaderToken(), // user must be logged in
          false,
        );

        await result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            Messages.getSnackMessage(
              "Success".tr,
              responseBody["message"].tr ?? "Password changed successfully".tr,
              ColorsManager.green,
            );
            final myService = Get.find<MyService>();
            await myService.clearAllUserData();
            Get.offAllNamed(Routes.loginScreen);
          },
        );
      }
    } catch (e) {
      Messages.getSnackMessage(
          "Error".tr, e.toString().tr, ColorsManager.primary);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> forgetPassword(String email) async {
    if (email.isEmpty || !email.contains("@")) {
      Messages.getSnackMessage(
          "Error".tr,
          'Email can\'t be empty, Email should Contain "@".'.tr,
          ColorsManager.primary);
      return;
    }
    try {
      isLoading = true;
      update();
      if (await NetworkManager().isOnline()) {
        final result = await Crud().postData(
          AppLink.forgetPassword, // maps to /forgetPassword
          {"email": email},
          AppLink().getHeader(), // no auth token required
          false,
        );

        await result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            Messages.getSnackMessage(
              "OTP Sent".tr,
              responseBody["message"].tr ?? "Check your email for the OTP".tr,
              ColorsManager.green,
            );
            // if success → go to OTP screen
            Get.to(() => OtpResetScreen(email: email));
          },
        );
      }
    } catch (e) {
      Messages.getSnackMessage(
          "Error".tr, e.toString().tr, ColorsManager.primary);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    if (email.isEmpty ||
        !email.contains("@") ||
        otp.isEmpty ||
        newPassword.isEmpty ||
        (newPassword.length < 6)) {
      Messages.getSnackMessage(
        "Follow These Rules:".tr,
        'resPassRules',
        ColorsManager.primary,
      );
      return;
    }
    try {
      isLoading = true;
      update();
      if (await NetworkManager().isOnline()) {
        final result = await Crud().postData(
          AppLink.resetPassword, // maps to /resetPassword
          {
            "email": email,
            "otp": otp,
            "newPassword": newPassword,
          },
          AppLink().getHeader(), // no auth required
          false,
        );

        await result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            Messages.getSnackMessage(
              "Success".tr,
              responseBody["message"].tr ?? "Password reset successful".tr,
              ColorsManager.green,
            );
            final myService = Get.find<MyService>();
            await myService.clearAllUserData();
            Get.offAllNamed(Routes.loginScreen);
          },
        );
      }
    } catch (e) {
      Messages.getSnackMessage(
          "Error".tr, e.toString().tr, ColorsManager.primary);
    } finally {
      isLoading = false;
      update();
    }
  }
}
