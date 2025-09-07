// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/data/model/achievments_model.dart';

import '../../../core/const_data/app_images.dart';

class AchievmentsCard extends StatelessWidget {
  const AchievmentsCard({super.key, required this.achievments});
  final List<AchievementsModel> achievments;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: List.generate(achievments.length, (index) {
        final thisAchievment = achievments[index];
        return Card(
          color: Theme.of(context).cardColor, // ✅ adaptive card background
          child: ListTile(
            leading: Icon(
              Icons.emoji_events,
              color: thisAchievment.isCompleted
                  ? Colors.amber
                  : Theme.of(context).iconTheme.color?.withOpacity(0.5),
              size: 40.r,
            ),
            title: Text(
              thisAchievment.title,
              style: TextStyles.bodyTextStyle(context).copyWith(
                color: Theme.of(context).colorScheme.primary, // ✅ adaptive
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thisAchievment.subTitle.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      'Progress: '.tr,
                      style: TextStyles.smallTextStyle(context).copyWith(
                        color: Colors.greenAccent.shade400, // ✅ brighter green
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (thisAchievment.isCompleted) ...[
                      Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent.shade400,
                        size: 22.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Completed".tr,
                        style: TextStyles.smallTextStyle(context).copyWith(
                          color: Colors.greenAccent.shade400,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: LinearProgressIndicator(
                          value: thisAchievment.progress / 100,
                          backgroundColor: isDark
                              ? Colors.grey[700]
                              : Colors.grey[300], // ✅ adaptive
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "${thisAchievment.progress} %",
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color, // ✅ adaptive
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget getNoAchievements() {
  return Builder(builder: (context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Complete your tasks and get awards:'.tr,
          style: TextStyles.bodyTextStyle(context).copyWith(
            fontSize: 18.sp,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).textTheme.bodyLarge?.color, // ✅ adaptive
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: SizedBox(
            height: 200.h,
            child: Image.asset(
              AppImages.achievements,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          "No_Achievements".tr,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color
                ?.withOpacity(0.6), // ✅ adaptive
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  });
}
