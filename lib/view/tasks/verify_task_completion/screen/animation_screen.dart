import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_with_notifications/core/const_data/app_animations.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';

class AnimationScreen extends StatelessWidget {
  final String animationName;
  final String? analysisText;
  final bool isCompleted;
  final bool isLoading;

  const AnimationScreen(
      {required this.animationName,
      required this.analysisText,
      required this.isCompleted,
      required this.isLoading,
      super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: isCompleted
          ? AppBar(
              title: Text(
                'Analyzing Complete!'.tr,
                style: TextStyles.headingTextStyle(context),
              ),
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(animationName, width: 400.w, height: 400.h),
          ),
          SizedBox(
            height: 20.h,
          ),
          isCompleted
              ? Container()
              : Center(
                  child: Text(
                    isLoading ? 'Loading_name'.tr : 'Analyzing...'.tr,
                    style: TextStyles.bodyTextStyle(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          showAnalysis(animationName, context),
          SizedBox(
            height: 30.h,
          ),
          isCompleted
              ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30.r,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  label: Text(
                    'Go Back'.tr,
                    style: TextStyles.smallTextStyle(context).copyWith(
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget showAnalysis(String animationName, BuildContext context) {
    if (animationName == AppAnimations.congratulations ||
        animationName == AppAnimations.failure) {
      return TextButton(
        onPressed: () {
          if (analysisText != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'AI Says:'.tr,
                  style: TextStyles.bodyTextStyle(context).copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  analysisText!,
                  style: TextStyles.smallTextStyle(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close'.tr,
                      style: TextStyles.bodyTextStyle(context).copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        child: Text(
          'Show Analysis'.tr,
          style: TextStyles.bodyTextStyle(context).copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }
    return SizedBox(
      height: 10.h,
    );
  }
}
