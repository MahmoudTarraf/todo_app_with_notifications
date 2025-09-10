// 📁 schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/utils/text_direction_helper.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';
import 'package:todo_app_with_notifications/widgets/floating_action_button_widget.dart';

import '../../../core/const_data/text_styles.dart';
import '../../tasks/incomplete_tasks/screen/task_card.dart';
import '../controller/schedule_controller.dart';

class ScheduleScreen extends StatelessWidget {
  final ScheduleController controller = Get.put(
    ScheduleController(),
  );
  final IncompleteTasksController incompleteTasksController = Get.put(
    IncompleteTasksController(),
    permanent: true,
  );

  ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule".tr,
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
      body: Directionality(
        textDirection: TextDirectionHelper.currentDirection,
        child: SafeArea(
          child: Obx(() {
            return Column(
              children: [
                // 🔹 TableCalendar Widget
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.selectedDate.value,
                  currentDay: controller.selectedDate.value,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  calendarFormat: CalendarFormat.week,
                  availableCalendarFormats: const {
                    CalendarFormat.week: 'Week',
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    headerPadding: const EdgeInsets.symmetric(
                        vertical: 8), // add vertical padding
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    defaultTextStyle: TextStyle(fontSize: 14.sp),

                    cellMargin: const EdgeInsets.symmetric(
                        vertical: 2), // tiny margin inside each cell
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                    weekdayStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(controller.selectedDate.value, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    controller.selectDate(selectedDay);
                  },
                ),

                // 🔹 Task List
                Expanded(
                  child: Obx(() {
                    final tasks = controller.filteredTasks;
                    final incompleteController =
                        Get.find<IncompleteTasksController>();

                    if (tasks.isEmpty) {
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
                              "🎉 ${'No tasks scheduled for'.tr} \n${DateFormat('EEEE, MMM d').format(controller.selectedDate.value)}!",
                              style: TextStyles.bodyTextStyle(context),
                              textAlign: TextAlign.center,
                              textDirection:
                                  TextDirectionHelper.currentDirection,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                          controller: incompleteController,
                        );
                      },
                    );
                  }),
                )
              ],
            );
          }),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ✅ always bottom right
      floatingActionButton: FloatingActionButtonWidget(),
    );
  }
}
