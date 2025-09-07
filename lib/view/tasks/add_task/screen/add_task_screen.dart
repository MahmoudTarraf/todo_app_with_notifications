import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';
import '../../../../../core/const_data/text_styles.dart';
import '../controller/add_task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final controller = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add New Task'.tr,
            style:
                TextStyles.headingTextStyle(context).copyWith(fontSize: 25.sp),
          ),
        ),
        body: Obx(() {
          final incompleteController =
              Get.put(IncompleteTasksController(), permanent: true);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task Type:'.tr, style: TextStyles.bodyTextStyle(context)),
                Row(
                  children: [
                    ChoiceChip(
                      checkmarkColor: controller.taskType.value == 'oneTime'
                          ? Colors.white
                          : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black), // unselected
                      label: Text(
                        'One-Time'.tr,
                        style: TextStyles.smallTextStyle(context).copyWith(
                          color: controller.taskType.value == 'oneTime'
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black), // unselected
                        ),
                      ),
                      selected: controller.taskType.value == 'oneTime',
                      onSelected: (_) => controller.taskType.value = 'oneTime',
                    ),
                    SizedBox(width: 10.w),
                    ChoiceChip(
                      checkmarkColor: controller.taskType.value == 'scheduled'
                          ? Colors.white
                          : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black), // unselected
                      label: Text(
                        'Scheduled'.tr,
                        style: TextStyles.smallTextStyle(context).copyWith(
                          color: controller.taskType.value == 'scheduled'
                              ? Colors.white
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black), // unselected
                        ),
                      ),
                      selected: controller.taskType.value == 'scheduled',
                      onSelected: (_) =>
                          controller.taskType.value = 'scheduled',
                    ),
                  ],
                ),
                if (controller.taskType.value == 'scheduled') ...[
                  SizedBox(height: 16.h),
                  Text('Frequency'.tr,
                      style: TextStyles.bodyTextStyle(context)),
                  DropdownButton<String>(
                    value: controller.frequency.value,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                          value: 'everyday', child: Text('Everyday'.tr)),
                      DropdownMenuItem(
                          value: 'everyweek', child: Text('Every Week'.tr)),
                      DropdownMenuItem(
                          value: 'custom',
                          child: Text('Choose Specific Dates'.tr)),
                    ],
                    onChanged: (val) => controller.frequency.value = val!,
                  ),
                  if (controller.frequency.value == 'custom') ...[
                    SizedBox(height: 14.h),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text('Add Date & Time'.tr),
                      onPressed: () =>
                          controller.pickScheduledDeadline(context),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8,
                      children: controller.selectedDeadlines.map((dateTime) {
                        return Chip(
                          label: Text(
                              DateFormat('MMM d, hh:mm a').format(dateTime)),
                          onDeleted: () => controller.toggleDate(dateTime),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    SizedBox(height: 16.h),
                    Text('theDeadline'.tr,
                        style: TextStyles.bodyTextStyle(context)),
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
                  ],
                ] else ...[
                  SizedBox(height: 16.h),
                  Text('theDeadline'.tr,
                      style: TextStyles.bodyTextStyle(context)),
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
                ],
                SizedBox(height: 16.h),
                Text('Priority'.tr, style: TextStyles.bodyTextStyle(context)),
                Row(
                  children: ['high', 'medium', 'low'].map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(p.toUpperCase().tr),
                        selected: controller.priority.value == p,
                        selectedColor: controller.getPriorityColor(context, p),
                        onSelected: (_) => controller.priority.value = p,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    labelText: 'Title'.tr,
                    labelStyle: TextStyles.bodyTextStyle(context),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.contentController,
                  decoration: InputDecoration(
                    labelText: 'Content'.tr,
                    labelStyle: TextStyles.bodyTextStyle(context),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                incompleteController.statusRequest.value ==
                        StatusRequest.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final taskData = controller.getTaskData();
                            controller.submitTask(taskData);
                          },
                          icon: Icon(
                            Icons.check,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          label: Text(
                            'Add_Task_ach'.tr,
                            style: TextStyles.smallTextStyle(context).copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                        ),
                      ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
