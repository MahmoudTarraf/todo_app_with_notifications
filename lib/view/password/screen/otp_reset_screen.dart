import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/view/password/controller/password_controller.dart';
import 'package:todo_app_with_notifications/widgets/custom_app_bar.dart';

import '../../../core/const_data/text_styles.dart';

class OtpResetScreen extends StatefulWidget {
  final String email;
  const OtpResetScreen({super.key, required this.email});

  @override
  State<OtpResetScreen> createState() => _OtpResetScreenState();
}

class _OtpResetScreenState extends State<OtpResetScreen> {
  String otp = "";
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
        appBar: CustomAppBar(title: "Reset Password".tr),
        body: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            children: [
              OtpTextField(
                numberOfFields: 6,
                borderColor: Theme.of(context).primaryColor,
                showFieldAsBox: true,
                onSubmit: (code) {
                  otp = code;
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
                        labelText: "  Enter New Password".tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: controller.isPasswordVisible
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
              SizedBox(height: 30.h),
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
                          await controller.resetPassword(
                              widget.email, otp, newPassword);
                        },
                        child: controller.isLoading
                            ? CircularProgressIndicator(
                                color: isDark ? Colors.black : Colors.white,
                              )
                            : Text(
                                "Reset Password Now".tr,
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
