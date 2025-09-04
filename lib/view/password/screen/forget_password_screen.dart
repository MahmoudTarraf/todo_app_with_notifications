import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/view/password/controller/password_controller.dart';
import 'package:todo_app_with_notifications/widgets/custom_app_bar.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String email = "";
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
        appBar: CustomAppBar(title: "Forgot Password".tr),
        body: Padding(
          padding: EdgeInsets.only(
            left: 10.r,
            right: 10.r,
          ),
          child: Column(
            children: [
              Container(
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Enter your email".tr,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (val) => email = val,
                ),
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
                          await controller.forgetPassword(email);
                        },
                        child: controller.isLoading
                            ? CircularProgressIndicator(
                                color: isDark ? Colors.black : Colors.white,
                              )
                            : Text(
                                "Send OTP".tr,
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
