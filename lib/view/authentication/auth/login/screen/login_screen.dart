import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/class/status_request.dart';
import '../../../../../core/const_data/app_images.dart';
import '../../../../../core/const_data/text_styles.dart';
import '../../../../../core/service/routes.dart';
import '../../../../../core/service/user_service.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import '../../../../../widgets/custom_text_form_field.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> thatKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userService = Get.find<UserService>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (controller) => Form(
            key: thatKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25.h),
                  ClipOval(
                    child: Container(
                      color: Colors.transparent, // Background color, if needed
                      child: Image.asset(
                        AppImages.goku,
                        width: 120.w,
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "ContinueWhere".tr,
                    style: TextStyles.headingTextStyle(context)
                        .copyWith(fontSize: 22.sp),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.r,
                      right: 10.r,
                    ),
                    child: CustomTextFormField(
                      suffixIcon: null,
                      containerWidth: double.infinity,
                      hintText: userService.currentUser?.email ?? 'Email'.tr,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (value) => controller.emailValidator(value),
                      onChanged: (_) => () {},
                      onSaved: (value) => controller.setEmail(value ?? ''),
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.r,
                      right: 10.r,
                    ),
                    child: CustomTextFormField(
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
                      obscureText: !controller.isPasswordVisible,
                      containerWidth: double.infinity,
                      hintText: "Password".tr,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) => controller.passwordValidator(value),
                      onChanged: (_) => () {},
                      onSaved: (value) => controller.setPassword(value ?? ''),
                      onEditingComplete: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?'.tr,
                          style: TextStyles.bodyTextStyle(context),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.signupScreen),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.r),
                            child: Text(
                              'Signup'.tr,
                              style: TextStyles.bodyTextStyle(context).copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: CustomElevatedButton(
                      width: double.infinity,
                      onPressed: () {
                        controller.verify(thatKey);
                      },
                      height: 70.h,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      child: controller.statusRequest == StatusRequest.loading
                          ? CircularProgressIndicator(
                              color: isDark ? Colors.black : Colors.white,
                            )
                          : Text(
                              "Login".tr,
                              style: TextStyles.bodyTextStyle(context).copyWith(
                                  color: isDark ? Colors.black : Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password?'.tr,
                          style: TextStyles.smallTextStyle(context),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.forgetPasswordScreen),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.r),
                            child: Text(
                              'Click Here'.tr,
                              style:
                                  TextStyles.smallTextStyle(context).copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
