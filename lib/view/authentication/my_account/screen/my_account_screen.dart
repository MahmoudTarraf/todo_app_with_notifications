import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';

import '../../../../core/service/messages.dart';
import '../../../../core/service/user_service.dart';
import '../controller/my_account_controller.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({super.key});

  final MyAccountController controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "My Account".tr,
              style: TextStyles.headingTextStyle(context),
            ),
            Obx(() {
              return IconButton(
                icon: controller.refreshLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.refresh,
                        size: 30.r,
                      ),
                onPressed: controller.refreshLoading.value
                    ? null // disable while loading
                    : () => controller.refreshUser(),
              );
            }),
          ],
        ),
      ),
      body: Obx(
        () {
          final thisUser =
              Get.find<UserService>().userModel.value; // reactive binding
          if (thisUser == null) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30.r),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.vertical,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Obx(() {
                          final controller = Get.put(MyAccountController());

                          return GestureDetector(
                            onTap: () => controller.pickImage(),
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: controller.selectedImage.value !=
                                      null
                                  ? FileImage(controller.selectedImage.value!)
                                  : AssetImage(
                                      AppImages.goku,
                                    ) as ImageProvider,
                            ),
                          );
                        }),
                        SizedBox(height: 20.h),

                        // Name
                        Text(
                          thisUser.name.toString(),
                          style: TextStyles.headingTextStyle(context)
                              .copyWith(fontSize: 22.sp),
                        ),
                        SizedBox(height: 8.h),

                        // Email
                        Text(
                          thisUser.email.toString(),
                          style: TextStyles.bodyTextStyle(context).copyWith(
                            color: theme.dividerColor
                                // ignore: deprecated_member_use
                                .withOpacity(0.7), // ✅ dynamic border
                          ),
                        ),
                        SizedBox(height: 20.h),

                        Divider(),

                        // Task Limits
                        _buildLimitTile(
                            "Remaining Updates".tr, thisUser.remainingUpdates),
                        _buildLimitTile(
                            "Remaining Deletes".tr, thisUser.remainingDeletes),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.taskStrikes);
                          },
                          child: _buildLimitTile(
                            "Tasks Strikes".tr,
                            thisUser.taskStrikes,
                            isStrike: true,
                          ),
                        ),

                        SizedBox(height: 30.h),
                        Divider(),

                        // Account Actions
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Change Name".tr),
                          onTap: () => _editField(
                            context,
                            "Change Name".tr,
                            thisUser.name.toString(),
                            (newName) => controller.updateName(
                              newName,
                              thisUser.name.toString(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text("Change Email".tr),
                          onTap: () => _editField(
                            context,
                            "Change Email".tr,
                            thisUser.email.toString(),
                            (newEmail) => controller.updateEmail(
                              newEmail,
                              thisUser.email.toString(),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.lock),
                          title: Text("Change Password".tr),
                          onTap: () => Get.toNamed(
                            Routes.changePasswordScreen,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 30.h),
                          child: ElevatedButton.icon(
                            icon: controller.isLoader.value
                                ? const SizedBox()
                                : Icon(
                                    Icons.logout,
                                    size: 25.r,
                                    color: isDark ? Colors.black : Colors.white,
                                  ),
                            label: controller.isLoader.value
                                ? CircularProgressIndicator(
                                    color: isDark ? Colors.black : Colors.white,
                                  )
                                : Text(
                                    "Logout".tr,
                                    style: TextStyles.bodyTextStyle(context)
                                        .copyWith(
                                      color:
                                          isDark ? Colors.black : Colors.white,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 12.h),
                            ),
                            onPressed: () async {
                              await controller.logout();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLimitTile(String title, int count, {bool isStrike = false}) {
    return Builder(builder: (context) {
      final theme = Theme.of(context);

      return ListTile(
        leading: Icon(
          isStrike ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: isStrike && count > 0
              ? theme.colorScheme.error // ✅ use theme error color
              : theme.iconTheme.color, // ✅ adapts to dark/light
        ),
        title: Text(
          title,
          style: TextStyles.bodyTextStyle(context), // ✅ dynamic text color
        ),
        trailing: Text(
          "$count/3",
          style: TextStyles.smallTextStyle(context).copyWith(
            color: isStrike && count > 0
                ? theme.colorScheme.error // ✅ red in both light/dark
                : theme.textTheme.bodyLarge?.color, // ✅ adapts
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  void _editField(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: initialValue);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogBackgroundColor, // ✅ adapts to dark/light
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        content: TextField(
          controller: controller,
          style: theme.textTheme.bodyMedium, // ✅ dynamic text
          decoration: InputDecoration(
            hintText: "Enter value".tr,
            hintStyle: theme.textTheme.bodySmall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                onSave(newValue);
              } else {
                Messages.getSnackMessage(
                  'Note'.tr,
                  'Field cannot be empty!'.tr,
                  theme.colorScheme.primary, // ✅ use theme primary color
                );
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: theme.colorScheme.primary), // ✅ adapts
            ),
          ),
        ],
      ),
    );
  }
}
