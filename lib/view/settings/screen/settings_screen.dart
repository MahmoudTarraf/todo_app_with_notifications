// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import '../../../core/utils/text_direction_helper.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirectionHelper.currentDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'settings'.tr, // 🔹 Now translated
            style: TextStyles.headingTextStyle(context),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔹 Theme
              ListTile(
                title:
                    Text('theme'.tr, style: TextStyles.bodyTextStyle(context)),
                trailing: DropdownButton<AppTheme>(
                  value: controller.theme.value,
                  items: [
                    DropdownMenuItem(
                      value: AppTheme.light,
                      child: Text(
                        'light'.tr,
                      ),
                    ),
                    DropdownMenuItem(
                        value: AppTheme.dark, child: Text('dark'.tr)),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.toggleTheme(value);
                  },
                ),
              ),
              Divider(),

              // 🔹 Language
              ListTile(
                title: Text('language'.tr,
                    style: TextStyles.bodyTextStyle(context)),
                trailing: Obx(() => AbsorbPointer(
                      absorbing: controller
                          .isUpdatingLanguage.value, // disable when updating
                      child: DropdownButton<String>(
                        value: controller.language.value,
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'ar', child: Text('العربية')),
                        ],
                        onChanged: (value) async {
                          if (value != null &&
                              !controller.isUpdatingLanguage.value) {
                            controller.isUpdatingLanguage.value =
                                true; // start updating
                            await controller.setLanguage(value);
                            controller.isUpdatingLanguage.value =
                                false; // done updating
                          }
                        },
                      ),
                    )),
              ),

              Divider(),

              // 🔹 Notifications
              SwitchListTile(
                title: Text('notifications'.tr,
                    style: TextStyles.bodyTextStyle(context)),
                value: controller.notificationsEnabled.value,
                onChanged: controller.isUpdatingNotifications.value
                    ? null
                    : controller.toggleNotifications,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
