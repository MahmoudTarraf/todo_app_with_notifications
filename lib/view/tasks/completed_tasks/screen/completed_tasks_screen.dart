import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/screen/task_card.dart';

import '../../../../widgets/floating_action_button_widget.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Tasks'.tr,
          style: TextStyles.headingTextStyle(context),
        ),
        actions: [
          GetBuilder<IncompleteTasksController>(
            builder: (controller) {
              return IconButton(
                icon: controller.isLoading
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
                onPressed: controller.isLoading
                    ? null
                    : () => controller.refreshTasks(),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<IncompleteTasksController>(
        init: IncompleteTasksController(),
        builder: (controller) {
          final completedTasks =
              controller.taskList.where((task) => task.isCompleted).toList();

          if (completedTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                    child: Image.asset(
                      AppImages.noData,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "✅ ${'No completed tasks yet.'.tr}\n${'Finish some tasks and they will appear here.'.tr}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              TaskModel task = completedTasks[index];
              return TaskCard(
                controller: controller,
                task: task,
              );
            },
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ✅ always bottom right
      floatingActionButton: FloatingActionButtonWidget(),
    );
  }
}
