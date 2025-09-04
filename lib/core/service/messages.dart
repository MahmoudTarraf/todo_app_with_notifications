import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const_data/app_colors.dart';

class Messages {
  static getSnackMessage(
    String title,
    String subTitle,
    Color backColor,
  ) {
    Get.snackbar(
      title,
      subTitle,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backColor,
      colorText: ColorsManager.white,
      duration: const Duration(
        seconds: 3,
      ),
    );
  }

  static Future<bool> onWillPop() async {
    bool shouldExit = false; // Variable to track if the app should close

    await Get.defaultDialog(
      backgroundColor: ColorsManager.white,
      buttonColor: ColorsManager.primary,
      title: "exit app?".tr,
      middleText: "Are you sure you want to leave?".tr,
      textCancel: "No".tr,
      textConfirm: "Yes".tr,
      confirmTextColor: Colors.white,
      onCancel: () {
        shouldExit = false; // Don't exit the app
        Get.back(); // Close the dialog
      },
      onConfirm: () {
        shouldExit = true; // Set to true to signal app exit
        Get.back(); // Close the dialog
      },
    );

    return shouldExit; // Return true if the user confirmed to exit
  }
}
