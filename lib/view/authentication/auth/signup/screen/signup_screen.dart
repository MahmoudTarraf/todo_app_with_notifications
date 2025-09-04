import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/widgets/custom_text_form_field.dart';

import '../../../../../core/service/messages.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final GlobalKey<FormState> _thisKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: Messages.onWillPop,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: GetBuilder<SignupController>(
            init: SignupController(),
            builder: (controller) => Form(
              key: _thisKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    ClipOval(
                      child: Container(
                        color:
                            Colors.transparent, // Background color, if needed
                        child: Image.asset(
                          AppImages.goku,
                          width: 120.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Create Your Account".tr,
                      style: TextStyles.headingTextStyle(context)
                          .copyWith(fontSize: 27.sp),
                    ),
                    SizedBox(height: 5.h),

                    // Username Field
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: CustomTextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (val) => controller.setName(val),
                        suffixIcon: null,
                        containerWidth: double.infinity,
                        hintText: "User Name".tr,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: controller.nameValidator,
                        onSaved: (value) => controller.setName(value ?? ''),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // Email Field
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.r,
                        right: 10.r,
                      ),
                      child: CustomTextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (email) => controller.setEmail(email),
                        suffixIcon: null,
                        containerWidth: double.infinity,
                        hintText: "Email Address".tr,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: controller.emailValidator,
                        onSaved: (value) => controller.setEmail(value ?? ''),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.r,
                        right: 10.r,
                      ),
                      child: CustomTextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) => controller.setPassword(value),
                        containerWidth: double.infinity,
                        hintText: "Password".tr,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        suffixIcon: IconButton(
                          color: controller.isPasswordVisible
                              ? Theme.of(context).primaryColor
                              : (isDark ? Colors.white : Colors.black),
                          icon: Icon(
                            controller.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        obscureText: !controller.isPasswordVisible,
                        validator: (value) =>
                            controller.passwordValidator(value),
                        onSaved: (value) => controller.setPassword(value ?? ''),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.r,
                        right: 10.r,
                      ),
                      child: CustomTextFormField(
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => () {},
                        containerWidth: double.infinity,
                        hintText: "Confirm Password".tr,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        ),
                        suffixIcon: IconButton(
                          color: controller.isPasswordAgainVisible
                              ? Theme.of(context).primaryColor
                              : (isDark ? Colors.white : Colors.black),
                          icon: Icon(
                            controller.isPasswordAgainVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.togglePasswordAgainVisibility,
                        ),
                        obscureText: !controller.isPasswordAgainVisible,
                        validator: (value) =>
                            controller.confirmPasswordValidator(value),
                        onSaved: (_) {},
                      ),
                    ),

                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?'.tr,
                            style: TextStyles.bodyTextStyle(context),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.loginScreen),
                            child: Padding(
                              padding: EdgeInsets.all(5.r),
                              child: Text(
                                'Login'.tr,
                                style:
                                    TextStyles.bodyTextStyle(context).copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //other ways of login

                    SizedBox(
                      height: 5.h,
                    ),
                    // Sign Up Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: CustomElevatedButton(
                        width: double.infinity,
                        onPressed: () {
                          controller.signUp();
                        },
                        height: 70.h,
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        child: controller.statusRequest == StatusRequest.loading
                            ? CircularProgressIndicator(
                                color: isDark ? Colors.black : Colors.white,
                              )
                            : Text(
                                "Signup".tr,
                                style: TextStyles.bodyTextStyle(context)
                                    .copyWith(
                                        color: isDark
                                            ? Colors.black
                                            : Colors.white),
                              ),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
