import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/data/model/failed_tasks_model.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/widgets/failed_task_card.dart';

import 'package:todo_app_with_notifications/widgets/floating_action_button_widget.dart';

import '../../../../core/const_data/text_styles.dart';
import '../../../../core/utils/text_direction_helper.dart';
import '../controller/my_account_controller.dart';

class TaskStrikesScreen extends StatelessWidget {
  const TaskStrikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyAccountController>();
    // 🔹 Force reload when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadFailedTasksFromServer();
    });
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Tasks Strikes'.tr,
          style: TextStyles.headingTextStyle(context),
        )),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // ✅ always bottom right
        floatingActionButton: FloatingActionButtonWidget(),

        body: Directionality(
          textDirection: TextDirectionHelper.currentDirection,
          child: GetBuilder<MyAccountController>(builder: (controller) {
            final failedTasks = controller.failedTasksList;

            return failedTasks.isEmpty
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
                          "${'🎉 No Strikes Yet!'.tr} \n ${'Keep going!'.tr}",
                          style: TextStyles.bodyTextStyle(context),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: failedTasks.length,
                    itemBuilder: (context, index) {
                      FailedTaskModel task = failedTasks[index];
                      return FailedTaskCard(
                        controller: controller,
                        task: task,
                      );
                    },
                  );
          }),
        ),
      ),
    );
  }
}
