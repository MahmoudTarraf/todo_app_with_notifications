import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // ✅ adapts to light/dark
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              AppImages.logo, // replace with your app logo
              width: 250.w,
              height: 250.h,
            ),
            const SizedBox(height: 20),
            // App name
            Text(
              "Achieve Your Goals".tr,
              style: TextStyles.bodyTextStyle(context).copyWith(
                color: theme.colorScheme.primary, // ✅ theme primary color
              ),
            ),
            SizedBox(height: 30.h),
            CircularProgressIndicator(
              color: theme.colorScheme.primary, // ✅ primary color adapts
            ),
            SizedBox(height: 10.h),
            Text(
              "Loading_name".tr,
              style: TextStyles.smallTextStyle(context).copyWith(
                color: theme
                    .colorScheme.secondary, // ✅ secondary color for contrast
              ),
            ),
          ],
        ),
      ),
    );
  }
}
