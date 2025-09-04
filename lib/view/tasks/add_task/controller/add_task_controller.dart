// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';
import 'package:todo_app_with_notifications/core/service/messages.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';

import '../../../../core/const_data/app_strings.dart';

class AddTaskController extends GetxController {
  final taskType = 'oneTime'.obs;
  final frequency = 'everyday'.obs;
  final priority = 'medium'.obs;
  final selectedDeadline = Rxn<DateTime>();
  final selectedDeadlines = <DateTime>[].obs;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Color getPriorityColor(BuildContext context, String priority) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (priority.toLowerCase()) {
      case 'high':
        return isDark ? Colors.red[300]! : Colors.red[700]!;
      case 'medium':
        return isDark ? Colors.orange[300]! : Colors.orange[700]!;
      case 'low':
        return isDark ? Colors.green[300]! : Colors.green[700]!;
      default:
        return isDark ? Colors.grey[400]! : Colors.grey[700]!;
    }
  }

  void toggleDate(DateTime date) {
    if (selectedDeadlines.contains(date)) {
      selectedDeadlines.remove(date);
    } else {
      selectedDeadlines.add(date);
    }
  }

  Future<void> pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        selectedDeadline.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  Future<void> pickScheduledDeadline(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final fullDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        toggleDate(fullDate);
      }
    }
  }

// needs to check for internet connection like isSynced and syncAction
  Map<String, dynamic> getTaskData() {
    return {
      AppStrings.tasksTitleColumnName: titleController.text,
      AppStrings.tasksContentColumnName: contentController.text,
      AppStrings.tasksTypeColumnName: taskType.value,
      AppStrings.tasksFrequencyColumnName:
          taskType.value == 'scheduled' ? frequency.value : 'N/A',
      AppStrings.tasksDatesColumnName:
          taskType.value == 'scheduled' && frequency.value == 'custom'
              ? selectedDeadlines.map((e) => e.toIso8601String()).toList()
              : 'N/A',
      AppStrings.tasksDeadlineColumnName: (taskType.value == 'oneTime' ||
              (taskType.value == 'scheduled' && frequency.value != 'custom'))
          ? selectedDeadline.value?.toIso8601String() ?? ''
          : 'N/A',
      AppStrings.tasksPriorityColumnName: priority.value,
      AppStrings.tasksIsCompletedColumnName: 0,
    };
  }

  void clearAll() {
    titleController.clear();
    contentController.clear();
    selectedDeadline.value = null;
    selectedDeadlines.clear();
    taskType.value = 'oneTime';
    frequency.value = 'everyday';
    priority.value = 'medium';
  }

  void submitTask(Map<String, dynamic> taskMap) {
    if (taskMap[AppStrings.tasksTitleColumnName] == "" ||
        taskMap[AppStrings.tasksContentColumnName] == "" ||
        taskMap[AppStrings.tasksDeadlineColumnName] == null) {
      Messages.getSnackMessage(
        'Note'.tr,
        'Please fill all the required fields!'.tr,
        ColorsManager.primary,
      );
      return;
    }
    final IncompleteTasksController incompleteController =
        Get.put(IncompleteTasksController());
    incompleteController.addTask(taskMap);
  }
}
