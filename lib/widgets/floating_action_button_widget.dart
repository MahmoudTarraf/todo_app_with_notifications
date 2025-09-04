import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      shape: BeveledRectangleBorder(),
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Theme.of(context).primaryColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.35,
      spacing: 5,
      spaceBetweenChildren: 5,
      children: [
        SpeedDialChild(
          labelStyle: TextStyle(fontSize: 18.sp),
          child: Icon(
            Icons.add,
            size: 30.r,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Add_Task_ach'.tr,
          onTap: () {
            Get.toNamed(Routes.addTaskScreen);
          },
        ),
        SpeedDialChild(
          labelStyle: TextStyle(fontSize: 18.sp),
          child: Icon(
            size: 30.r,
            Icons.note_add,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Add_Note_ach'.tr,
          onTap: () {
            Get.toNamed(Routes.addNotesScreen);
          },
        ),
      ],
    );
  }
}
