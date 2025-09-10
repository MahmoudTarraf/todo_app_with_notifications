import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_with_notifications/core/const_data/app_animations.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/core/service/messages.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';

import '../../../../core/utils/text_direction_helper.dart';

class WarningStrikesScreen extends StatelessWidget {
  final String animationName;
  final int taskStrikes;

  const WarningStrikesScreen({
    required this.animationName,
    required this.taskStrikes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: Messages.onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            taskStrikes >= 3 ? 'Account Deleted!'.tr : 'Warning!'.tr,
            style: TextStyles.headingTextStyle(context),
            textDirection: TextDirectionHelper.currentDirection,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(animationName, width: 400.w, height: 400.h),
            ),
            SizedBox(height: 20.h),
            showText(
              animationName: animationName,
              context: context,
              taskStrikes: taskStrikes,
            ),
            SizedBox(height: 30.h),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              icon: Icon(
                Icons.arrow_back,
                size: 30.r,
                color: theme.colorScheme.onPrimary, // ✅ adapts to theme
              ),
              onPressed: () {
                if (taskStrikes >= 3) {
                  Get.offAllNamed(Routes.signupScreen);
                } else {
                  Get.offAllNamed(Routes.homeScreen);
                }
              },
              label: Text(
                'Close'.tr,
                style: TextStyles.smallTextStyle(context).copyWith(
                  color: theme.colorScheme.onPrimary, // ✅ adapts
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showText({
    required String animationName,
    required BuildContext context,
    required int taskStrikes,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface; // ✅ dynamic text color

    if (animationName == AppAnimations.accountDeleted) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.r),
        child: Center(
          child: Text(
            '${"accountDel".tr} $taskStrikes ${"Strikes".tr}',
            style: TextStyles.bodyTextStyle(context).copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: textColor,
            ),
            textDirection: TextDirectionHelper.currentDirection,
          ),
        ),
      );
    } else if (animationName == AppAnimations.warning) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.r),
        child: Center(
          child: Text(
            '${"You already have".tr} $taskStrikes ${"Strikes".tr}, ${3 - taskStrikes} ${"Strikes left.".tr}',
            style: TextStyles.bodyTextStyle(context).copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: textColor,
            ),
            textDirection: TextDirectionHelper.currentDirection,
          ),
        ),
      );
    }
    return SizedBox(height: 10.h);
  }
}
