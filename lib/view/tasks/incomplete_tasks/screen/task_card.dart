import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';
import 'package:todo_app_with_notifications/core/service/messages.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/core/service/user_service.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';
import 'package:todo_app_with_notifications/view/tasks/update_tasks/screen/update_tasks_screen.dart';
import '../../../../core/const_data/text_styles.dart';
import '../../../../core/utils/format_deadline.dart';
import '../../../../core/utils/format_scheduled_dates.dart';
import '../../../../data/model/task_settings.dart';
import '../../../../core/utils/get_priority_color.dart';

// ignore: must_be_immutable
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.controller,
  });
  final TaskModel task;
  final IncompleteTasksController controller;

  @override
  Widget build(BuildContext context) {
    final thisUser = Get.find<UserService>().currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "What would you like to do?".tr,
                    style: TextStyles.headingTextStyle(context),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: thisUser!.remainingUpdates > 0
                            ? () async {
                                await Get.to(
                                  () => UpdateTasksScreen(
                                    task: task,
                                    incompleteController: controller,
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            : Messages.getSnackMessage(
                                'Can\'t Update!'.tr,
                                'Remaining Updates are 0.'.tr,
                                ColorsManager.grey,
                              ),
                        icon: Icon(
                          Icons.edit,
                          color: isDark ? Colors.black : Colors.white,
                        ),
                        label: Text(
                          "${'Update'.tr} (${thisUser.remainingUpdates})",
                          style: TextStyle(
                              color: isDark ? Colors.black : Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? ColorsManager.darkThemeColor
                              : ColorsManager.lightThemeColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: thisUser.remainingDeletes > 0
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm Delete'.tr),
                                    content: Text(
                                      '${"Are you sure you want to delete this task?".tr}\n${"You will have".tr} ${thisUser.remainingDeletes - 1} ${"delete(s) left.".tr}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'.tr),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          controller.deleteTask(task.id!);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Delete'.tr,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.delete,
                          color: isDark ? Colors.white : Colors.black,
                          size: 25.r,
                        ),
                        label: Text(
                          "${'Delete'.tr} (${thisUser.remainingDeletes})",
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDark ? Colors.redAccent : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Title & Priority Icon
              Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor:
                        getPriorityColor(context, task.taskPriority.name),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyles.bodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    task.isCompleted
                        ? Icons.check_circle_outline
                        : Icons.highlight_off_rounded,
                    color: task.isCompleted ? Colors.green : Colors.redAccent,
                    size: 35.r,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 📝 Content (optional)
              if (task.content.trim().isNotEmpty)
                Text(
                  task.content,
                  style: TextStyles.bodyTextStyle(context).copyWith(
                      color: isDark ? Colors.white70 : Colors.black87),
                ),

              if (task.content.trim().isNotEmpty) const SizedBox(height: 12),

              // 📅 Date Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 23.r,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.taskType == TaskType.oneTime
                          ? '${"One-time Deadline:".tr}\n${formatDeadline(task.deadline.toString())}'
                          : task.frequency == 'custom'
                              ? '${"Scheduled on:".tr}\n${formatScheduledDates(task.dates)}'
                              : '${"Repeats".tr} ${task.frequency}\n${"Deadline:".tr} ${formatDeadline(task.deadline.toString())}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ Mark as Completed Button
              if (!task.isCompleted)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        Routes.verifyTaskCompletionScreen,
                        arguments: task,
                      );
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 25.r,
                    ),
                    label: Text(
                      "Verify Completion".tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
