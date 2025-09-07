import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_with_notifications/view/home/controller/home_controller.dart';
import 'package:todo_app_with_notifications/view/home/screen/home_page.dart';
import 'package:todo_app_with_notifications/view/notes/screen/notes_screen.dart';
import 'package:todo_app_with_notifications/view/schedule/screen/schedule_screen.dart';
import 'package:todo_app_with_notifications/view/tasks/completed_tasks/screen/completed_tasks_screen.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/screen/incomplete_tasks_screen.dart';

import '../../../core/const_data/app_colors.dart';
import '../../../core/service/messages.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Widget getWidgets(int index) {
    switch (index) {
      case 0:
        // for admin login and signup and other stuff
        return IncompleteTasksScreen();
      case 1:
        return ScheduleScreen();
      case 2:
        return const HomePage();
      case 3:
        //categories
        return NotesScreen();
      case 4:
        //categories
        return const CompletedTasksScreen();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController(), permanent: true);
    final HomeController controller = Get.find<HomeController>();
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: Messages.onWillPop,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) {
                return getWidgets(controller.selectedIndex);
              },
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            animationCurve: Curves.bounceIn,
            animationDuration: const Duration(seconds: 1),
            color: Theme.of(context).primaryColor, // dynamic icon color
            height: 60.h,
            buttonBackgroundColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.transparent,
            index: controller.selectedIndex,
            onTap: (int index) {
              controller.updateIndex(index);
            },
            items: [
              Icon(
                Icons.highlight_off_rounded,
                color: ColorsManager.black,
                size: 35.r,
              ),
              Icon(
                Icons.timeline_outlined,
                color: ColorsManager.black,
                size: 35.r,
              ),
              Icon(
                Icons.home,
                size: 35.r,
                color: ColorsManager.black,
              ),
              Icon(
                Icons.note,
                size: 35.r,
                color: ColorsManager.black,
              ),
              Icon(
                Icons.done_all_outlined,
                size: 35.r,
                color: ColorsManager.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
