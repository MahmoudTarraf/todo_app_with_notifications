// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/core/utils/text_direction_helper.dart';
import 'package:todo_app_with_notifications/view/achievments/screen/achievments_card.dart';
import 'package:todo_app_with_notifications/widgets/drawer.dart';
import 'package:todo_app_with_notifications/widgets/floating_action_button_widget.dart';

import '../../../core/service/user_service.dart';
import '../../../initial_screen_controller.dart';
import '../../achievments/controller/achievments_controller.dart';
import '../../authentication/my_account/controller/my_account_controller.dart';
import '../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put the AchievementsController
    final achController = Get.put(AchievementsController());
    final homeController = Get.find<HomeController>();
    Get.put(InitialScreenController());

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: AppDrawer(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // ✅ always bottom right

        floatingActionButton: FloatingActionButtonWidget(),

        body: Directionality(
          textDirection: TextDirectionHelper.currentDirection,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome + Avatar + Refresh
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final userService = Get.find<UserService>();

                          final nameText = userService.currentUser?.name;
                          if (nameText == null) {
                            return Text(
                              'Loading_name'.tr,
                              style: TextStyles.headingTextStyle(context)
                                  .copyWith(fontStyle: FontStyle.italic),
                            );
                          }
                          return RichText(
                            text: TextSpan(
                              style: TextStyles.headingTextStyle(context)
                                  .copyWith(fontStyle: FontStyle.italic),
                              children: [
                                TextSpan(text: 'Welcome'.tr),
                                TextSpan(
                                  text: '$nameText !',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize:
                                        TextStyles.headingTextStyle(context)
                                            .fontSize,
                                    fontWeight:
                                        TextStyles.headingTextStyle(context)
                                            .fontWeight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      // Refresh button
                      Obx(() {
                        return IconButton(
                          icon: achController.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  Icons.refresh,
                                  size: 30.r,
                                ),
                          onPressed: achController.isLoading.value
                              ? null // disable while loading
                              : () => achController.refreshAchievements(),
                        );
                      }),

                      // Drawer avatar
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Obx(() {
                            final accController =
                                Get.put(MyAccountController());

                            return CircleAvatar(
                              radius: 35.r,
                              backgroundImage:
                                  accController.selectedImage.value != null
                                      ? FileImage(
                                          accController.selectedImage.value!)
                                      : AssetImage(
                                          AppImages.goku,
                                        ) as ImageProvider,
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (homeController.upcomingTaskCount.value == 0) {
                      return SizedBox(
                        height: 10.h,
                      );
                    }
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.amber[900]?.withOpacity(0.3)
                            : Colors.amber[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.amberAccent
                                    : Colors.amber[800],
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              homeController.upcomingTaskText.value,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.amberAccent
                                    : Colors.amber[800],
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Daily Summary
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 3,
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryItem(context, 'Due Today'.tr,
                                homeController.tasksDueToday.value.toString()),
                            _buildSummaryItem(context, 'Today’s Completed'.tr,
                                homeController.tasksCompleted.value.toString()),
                            _buildSummaryItem(
                              context,
                              '${'Streak'.tr} ${homeController.streak.value > 0 ? "🔥" : "❄️"}',
                              '${homeController.streak.value} ${'days'.tr}',
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Motivation Quote
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Obx(
                      () => Text(
                        achController.motivationalQuote.value,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Achievements using Obx
                  Obx(() {
                    final all = achController.achievementsList;

                    if (all.isEmpty) {
                      return getNoAchievements();
                    }

                    // Separate completed and in-progress
                    final completed = all.where((a) => a.isCompleted).toList();
                    final inProgress =
                        all.where((a) => !a.isCompleted).toList();

                    // Take up to 3 completed
                    final list = completed.take(3).toList();

                    // If fewer than 3 → fill with in-progress
                    if (list.length < 3) {
                      final remaining = 3 - list.length;
                      list.addAll(inProgress.take(remaining));
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AchievmentsCard(
                          achievments: list,
                        ),
                        if (all.length > 3) // Only show button if more exist
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.achievementsScreen);
                            },
                            child: Text(
                              'See All'.tr,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 128, 102, 175),
                                fontSize: 20.sp,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromARGB(255, 103, 74, 155),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSummaryItem(BuildContext context, String label, String value) {
  return Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      SizedBox(height: 4.h),
      Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
        ),
      ),
    ],
  );
}
