// ignore_for_file: use_key_in_widget_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import '../../../../core/const_data/app_images.dart';
import '../../../../core/const_data/text_styles.dart';
import '../../../../core/service/routes.dart';
import '../../../../initial_screen_controller.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});
  final controller = Get.put(InitialScreenController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pages = [
      PageViewModel(
        bubbleBackgroundColor: theme.colorScheme.primary, // dynamic
        pageColor: theme.scaffoldBackgroundColor, // dynamic
        bubble: Image.asset(AppImages.multipleTasks),
        body: Text(
          'easAdd'.tr,
          style: TextStyles.bodyTextStyle(context).copyWith(
            color: theme.textTheme.bodyLarge?.color, // dynamic
          ),
          textAlign: TextAlign.center,
        ),
        title: Text(
          'Manage Your Tasks'.tr,
          style: TextStyles.headingTextStyle(context).copyWith(
            color: theme.textTheme.headlineMedium?.color, // dynamic
          ),
          textAlign: TextAlign.center,
        ),
        mainImage: Image.asset(AppImages.multipleTasks),
      ),
      PageViewModel(
        bubbleBackgroundColor: theme.colorScheme.primary,
        pageColor: theme.scaffoldBackgroundColor,
        bubble: Image.asset(AppImages.planTask),
        body: Text(
          'planTasks'.tr,
          style: TextStyles.bodyTextStyle(context).copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
          textAlign: TextAlign.center,
        ),
        title: Text(
          'Stay Organized'.tr,
          style: TextStyles.headingTextStyle(context).copyWith(
            color: theme.textTheme.headlineMedium?.color,
          ),
          textAlign: TextAlign.center,
        ),
        mainImage: Image.asset(AppImages.planTask),
      ),
      PageViewModel(
        bubbleBackgroundColor: theme.colorScheme.primary,
        pageColor: theme.scaffoldBackgroundColor,
        bubble: Image.asset(AppImages.taskNotification),
        body: Text(
          'neverMiss'.tr,
          style: TextStyles.bodyTextStyle(context).copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
          textAlign: TextAlign.center,
        ),
        title: Text(
          'Smart Notifications'.tr,
          style: TextStyles.headingTextStyle(context).copyWith(
            color: theme.textTheme.headlineMedium?.color,
          ),
          textAlign: TextAlign.center,
        ),
        mainImage: Image.asset(AppImages.taskNotification),
      ),
    ];

    return IntroViewsFlutter(
      backText: Text(
        "Back".tr,
        style: TextStyle(color: theme.colorScheme.primary),
      ),
      nextText: Text(
        "Next".tr,
        style: TextStyle(color: theme.colorScheme.primary),
      ),
      skipText: Text(
        "Skip".tr,
        style: TextStyle(color: theme.colorScheme.primary),
      ),
      doneText: Text(
        "Done".tr,
        style: TextStyle(color: theme.colorScheme.primary),
      ),
      pages,
      showNextButton: true,
      showBackButton: true,
      onTapDoneButton: () {
        Get.offAndToNamed(Routes.signupScreen);
      },
      pageButtonTextStyles: TextStyle(
        color: theme.colorScheme.primary,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
