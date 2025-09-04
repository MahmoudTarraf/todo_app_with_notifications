import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';

import '../../../../data/model/task_settings.dart';

class UpdateTasksController extends GetxController {
  late TaskModel task;
  late IncompleteTasksController taskController;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  Rx<DateTime?> selectedDeadline = Rx<DateTime?>(null);
  RxString priority = ''.obs;

  void init(TaskModel task, IncompleteTasksController controller) {
    this.task = task;
    taskController = controller;

    titleController.text = task.title;
    contentController.text = task.content;
    selectedDeadline.value = task.deadline;
    priority.value = task.taskPriority.name;
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> pickDeadline(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
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

  void submitUpdate() {
    task.title = titleController.text;
    task.content = contentController.text;
    task.deadline = selectedDeadline.value;
    task.taskPriority =
        TaskPriority.values.firstWhere((e) => e.name == priority.value);
    taskController.updateTask(task, true);
  }

  void deleteTask() {
    taskController.deleteTask(task.id!);
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
