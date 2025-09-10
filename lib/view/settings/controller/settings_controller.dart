// settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/my_service.dart';
import 'package:todo_app_with_notifications/core/service/shared_prefrences_keys.dart';
import 'package:todo_app_with_notifications/initial_screen_controller.dart';
import 'package:todo_app_with_notifications/view/achievments/controller/achievments_controller.dart';
import '../../../core/class/crud.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/service/app_link.dart';
import '../../../core/service/messages.dart';
import '../../../core/service/network_manager.dart';

enum AppTheme { light, dark }

class SettingsController extends GetxController {
  Rx<AppTheme> theme = AppTheme.light.obs;
  Rx<String> language = 'en'.obs;
  Rx<bool> notificationsEnabled = true.obs;
  RxBool isUpdatingNotifications = false.obs; // 🔹 New flag
  RxBool isUpdatingLanguage = false.obs; // 🔹 New flag

  final myService = Get.find<MyService>();

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    // Theme
    String? savedTheme = myService.getStringData(SharedPrefrencesKeys.theme);
    if (savedTheme != null && savedTheme == SharedPrefrencesKeys.dark) {
      theme.value = AppTheme.dark;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      theme.value = AppTheme.light;
      Get.changeThemeMode(ThemeMode.light);
    }

    // Language
    language.value = myService.getStringData(SharedPrefrencesKeys.language) ??
        SharedPrefrencesKeys.en;
    Get.updateLocale(Locale(language.value)); // 🔹 Apply saved language

    // Notifications
    notificationsEnabled.value =
        myService.getBoolData(SharedPrefrencesKeys.notifications) ?? true;
  }

  // Theme toggle
  void toggleTheme(AppTheme selectedTheme) async {
    theme.value = selectedTheme;
    Get.changeThemeMode(
        selectedTheme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light);
    await myService.storeStringData(
      SharedPrefrencesKeys.theme,
      selectedTheme == AppTheme.dark
          ? SharedPrefrencesKeys.dark
          : SharedPrefrencesKeys.light,
    );
  }

  // Language toggle
  Future<void> setLanguage(String langCode) async {
    language.value = langCode;
    Get.updateLocale(Locale(langCode)); // 🔹 Update locale immediately
    await myService.storeStringData(SharedPrefrencesKeys.language, langCode);

    final achController = Get.put(AchievementsController());
    await achController.getMotivationalQuote();
  }

// 🔹 Toggle Notifications (local + server)
  Future<void> toggleNotifications(bool enabled) async {
    if (isUpdatingNotifications.value) return; // 🔹 Prevent spamming
    isUpdatingNotifications.value = true;
    try {
      if (await NetworkManager().isOnline()) {
        // 4️⃣ Update server first
        final fields = {"notificationsOn": enabled ? 1 : 0};

        final result = await Crud().putData(
          AppLink.updateUserDetails,
          fields,
          AppLink().getHeaderToken(),
        );

        result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              "Failed to update notifications".tr,
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            // ✅ Only save locally if server update succeeds
            notificationsEnabled.value = enabled;
            await myService.storeBoolData(
              SharedPrefrencesKeys.notifications,
              enabled,
            );

            Messages.getSnackMessage(
              "Success".tr,
              "Notifications setting updated successfully".tr,
              ColorsManager.green,
            );
            if (enabled == true) {
              final temp = Get.put(
                InitialScreenController(),
              );
              await temp.checkConnectivity();
            }
          },
        );
      } else {
        // Offline: only show warning, don't change local value
        Messages.getSnackMessage(
          "No Internet".tr,
          "Notifications setting could not be updated".tr,
          ColorsManager.grey,
        );
      }
    } catch (e) {
      Messages.getSnackMessage(
        "Error".tr,
        e.toString().tr,
        ColorsManager.primary,
      );
    } finally {
      isUpdatingNotifications.value = false; // 🔹 Re-enable
    }
  }
}
