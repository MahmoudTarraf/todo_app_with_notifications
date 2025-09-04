import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/view/password/controller/password_controller.dart';

import '../../../core/const_data/text_styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPassword = "";
  String newPassword = "";

  final PasswordController controller = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "Change Password".tr,
          style: TextStyles.headingTextStyle(context).copyWith(fontSize: 28.sp),
        )),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              GetBuilder<PasswordController>(
                builder: (controller) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: theme.dividerColor,
                      ),
                      // ignore: deprecated_member_use
                      color: theme.cardColor.withOpacity(0.7),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      obscureText: !controller.isOldPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "oldPassword".tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: controller.isOldPasswordVisible
                                ? Theme.of(context).primaryColor
                                : (isDark ? Colors.white : Colors.black),
                            controller.isOldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.toggleOldPasswordVisibility,
                        ),
                      ),
                      onChanged: (val) => oldPassword = val,
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
              GetBuilder<PasswordController>(
                builder: (controller) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: theme.dividerColor,
                      ),
                      // ignore: deprecated_member_use
                      color: theme.cardColor.withOpacity(0.7),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      obscureText: !controller.isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "newPassword".tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: controller.isOldPasswordVisible
                                ? Theme.of(context).primaryColor
                                : (isDark ? Colors.white : Colors.black),
                            controller.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      onChanged: (val) => newPassword = val,
                    ),
                  );
                },
              ),
              SizedBox(height: 35.h),
              GetBuilder<PasswordController>(
                builder: (controller) {
                  return Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Container(
                      margin: EdgeInsets.all(7.r),
                      width: double.infinity,
                      height: 70.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await controller.changePassword(
                            oldPassword,
                            newPassword,
                          );
                        },
                        child: controller.isLoading
                            ? CircularProgressIndicator(
                                color: isDark ? Colors.black : Colors.white,
                              )
                            : Text(
                                "Change Password Now".tr,
                                style: TextStyles.bodyTextStyle(context)
                                    .copyWith(
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
