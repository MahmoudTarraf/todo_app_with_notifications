import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/data/model/failed_tasks_model.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/controller/my_account_controller.dart';

import '../../../../core/const_data/text_styles.dart';
import '../../../../core/utils/format_deadline.dart';
import '../../../../core/utils/format_scheduled_dates.dart';
import '../../../../data/model/task_settings.dart';
import '../../../../core/utils/get_priority_color.dart';

// ignore: must_be_immutable
class FailedTaskCard extends StatelessWidget {
  const FailedTaskCard({
    super.key,
    required this.task,
    required this.controller,
  });
  final FailedTaskModel task;
  final MyAccountController controller;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
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
                    ),
                  ),
                ),
                Icon(
                  task.isCompleted
                      ? Icons.check_circle_outline
                      : Icons.highlight_off_rounded,
                  color: task.isCompleted ? Colors.green : Colors.red,
                  size: 35.r,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 📝 Content (optional)
            if (task.content.trim().isNotEmpty)
              Text(
                task.content,
                style: TextStyles.bodyTextStyle(context),
              ),

            if (task.content.trim().isNotEmpty) const SizedBox(height: 12),

            // 📅 Date Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.schedule, size: 23.r, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.taskType == TaskType.oneTime
                        ? '${"One-time Deadline:".tr}\n${formatDeadline(
                            task.deadline.toString(),
                          )}'
                        : task.frequency == 'custom'
                            ? '${"Scheduled on:".tr}\n${formatScheduledDates(task.dates)}'
                            : '${"Repeats".tr} ${task.frequency}\n${"Deadline:".tr} ${formatDeadline(
                                task.deadline.toString(),
                              )}',
                    style: TextStyle(fontSize: 15.sp, color: Colors.black54),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
// 📅 Failed At Info
            if (task.failedAt != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline,
                      size: 23.r, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${"Failed At:".tr}\n${formatDeadline(task.failedAt.toString())}',
                      style:
                          TextStyle(fontSize: 15.sp, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
