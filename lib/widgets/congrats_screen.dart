import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';

import '../core/utils/text_direction_helper.dart';

class CongratsScreen extends StatelessWidget {
  final String animationName;
  final int streak;

  const CongratsScreen({
    super.key,
    required this.animationName,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'congrats'.tr,
          style: TextStyles.headingTextStyle(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(animationName, width: 400.w, height: 400.h),
          ),
          SizedBox(
            height: 20.h,
          ),
          showCongratsText(context, streak),
          SizedBox(
            height: 30.h,
          ),
          ElevatedButton.icon(
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
          ),
        ],
      ),
    );
  }
}

Widget showCongratsText(BuildContext context, int streak) {
  final isArabic = Get.locale?.languageCode == 'ar';

  return Padding(
    padding: EdgeInsets.all(8.0.r),
    child: Text(
      textDirection: TextDirectionHelper.currentDirection,
      isArabic
          ? '🎉 تهانينا! لقد حققت سلسلة مدتها $streak يوم!\nلقد حصلت على +3 تحديثات، +3 حذف، وتم إزالة خطأ واحد.'
          : '🎉 Congrats! You hit a $streak-day streak!\nYou earned +3 updates, +3 deletes, 1 strike removed.',
      textAlign: TextAlign.center,
      style: TextStyles.bodyTextStyle(context),
    ),
  );
}
