// 📁 update_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/core/service/user_service.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';

import '../controller/update_tasks_controller.dart';

class UpdateTasksScreen extends StatelessWidget {
  final TaskModel task;
  final IncompleteTasksController incompleteController;

  UpdateTasksScreen(
      {super.key, required this.task, required this.incompleteController}) {
    Get.put(UpdateTasksController()).init(task, incompleteController);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final thisUser = Get.find<UserService>().currentUser;

    final controller = Get.find<UpdateTasksController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task'.tr,
          style: TextStyles.headingTextStyle(context),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Obx(
          () {
            final incompleteController =
                Get.put(IncompleteTasksController(), permanent: true);
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Text('Title'.tr, style: TextStyles.bodyTextStyle(context)),
                  TextField(controller: controller.titleController),
                  SizedBox(height: 20.h),
                  Text('Content'.tr, style: TextStyles.bodyTextStyle(context)),
                  TextField(
                      controller: controller.contentController, maxLines: 4),
                  SizedBox(height: 20.h),
                  Text('Priority'.tr, style: TextStyles.bodyTextStyle(context)),
                  Row(
                    children: ['high', 'medium', 'low'].map((p) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(p.toUpperCase().tr),
                          selected: controller.priority.value == p,
                          selectedColor: controller.getPriorityColor(p),
                          onSelected: (_) => controller.priority.value = p,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  Text('Deadline'.tr, style: TextStyles.bodyTextStyle(context)),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      controller.selectedDeadline.value == null
                          ? 'Pick Deadline'.tr
                          : DateFormat('MMM d, y – hh:mm a')
                              .format(controller.selectedDeadline.value!),
                    ),
                    onPressed: () => controller.pickDeadline(context),
                  ),
                  SizedBox(height: 30.h),
                  incompleteController.statusRequest.value ==
                          StatusRequest.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Confirm Update'.tr,
                                    style: TextStyles.bodyTextStyle(context),
                                  ),
                                  content: Text(
                                    '${"Are you sure you want to update this task?".tr}\n${"You will have".tr} ${thisUser!.remainingUpdates - 1} ${"update(s) left.".tr}',
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'.tr),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        controller.submitUpdate();
                                      },
                                      child: Text(
                                        'update'.tr,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.update,
                              color: isDark ? Colors.black : Colors.white,
                              size: 30.r,
                            ),
                            label: Text(
                              'UpdateTheTask'.tr,
                              style:
                                  TextStyles.smallTextStyle(context).copyWith(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
