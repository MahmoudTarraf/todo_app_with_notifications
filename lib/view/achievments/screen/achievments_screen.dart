import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/user_service.dart';

import '../../../core/const_data/app_images.dart';
import '../../../core/const_data/text_styles.dart';
import '../controller/achievments_controller.dart';
import 'achievments_card.dart';

class AchievmentsScreen extends StatelessWidget {
  const AchievmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achController = Get.put(AchievementsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Achievements'.tr,
          style: TextStyles.headingTextStyle(context),
        ),
        actions: [
          Obx(
            () {
              return IconButton(
                icon: achController.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Icon(
                        color: Theme.of(context).primaryColor,
                        Icons.refresh,
                        size: 30,
                      ),
                onPressed: achController.isLoading.value
                    ? null
                    : () => achController.getAchievements(
                        Get.find<UserService>().currentUser!.id),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Obx(() {
          final all = achController.achievementsList;
          if (all.isEmpty) {
            return Center(
              child: Column(
                children: [
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
                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Split into completed and in-progress
          final completed = all.where((a) => a.isCompleted).toList();
          final inProgress = all.where((a) => !a.isCompleted).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (completed.isNotEmpty) ...[
                  Text(
                    '${"Completed".tr} :',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.green.shade300
                          : Colors.green.shade600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  AchievmentsCard(achievments: completed),
                  SizedBox(height: 20.h),
                ],
                if (inProgress.isNotEmpty) ...[
                  Text(
                    '${"In Progress".tr} :',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.deepPurple.shade200
                          : Colors.deepPurple.shade600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  AchievmentsCard(achievments: inProgress),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
