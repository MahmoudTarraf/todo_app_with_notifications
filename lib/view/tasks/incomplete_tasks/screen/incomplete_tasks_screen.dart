import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/screen/task_card.dart';
import 'package:todo_app_with_notifications/widgets/floating_action_button_widget.dart';

class IncompleteTasksScreen extends StatelessWidget {
  IncompleteTasksScreen({super.key});
  final IncompleteTasksController con =
      Get.put(IncompleteTasksController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // centers the title
        title: Text(
          'My Tasks'.tr,
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
      body: GetBuilder<IncompleteTasksController>(builder: (controller) {
        final incompleteTasks =
            controller.taskList.where((task) => !task.isCompleted).toList();

        return incompleteTasks.isEmpty
            ? Center(
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
                      "No_tasks_here".tr,
                      style: TextStyles.bodyTextStyle(context),
                      textAlign: TextAlign.center,
                      textDirection: Get.locale?.languageCode == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr, // RTL for Arabic
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: incompleteTasks.length,
                itemBuilder: (context, index) {
                  TaskModel task = incompleteTasks[index];
                  return TaskCard(
                    controller: controller,
                    task: task,
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButtonWidget(),
    );
  }
}
