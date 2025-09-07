import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  State<FloatingActionButtonWidget> createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  // Initial position (bottom right)
  Offset position = const Offset(310, 680);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final buttonWidth = 70.w;
    final buttonHeight = 70.h;

    // AppBar height (use kToolbarHeight if it’s a normal AppBar)
    final double appBarHeight = kToolbarHeight + padding.top;

    // Reserve space for bottom nav / safe area
    final double bottomSafeArea = padding.bottom + 70; // 70 = button min margin

    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: _buildSpeedDial(context),
            childWhenDragging: const SizedBox.shrink(),
            child: _buildSpeedDial(context),
            onDragEnd: (details) {
              setState(() {
                double newX = details.offset.dx;
                double newY = details.offset.dy;

                // Clamp X within screen
                newX = newX.clamp(0, screenSize.width - buttonWidth);

                // Clamp Y within safe area (AppBar down to bottom nav area)
                newY = newY.clamp(appBarHeight,
                    screenSize.height - buttonHeight - bottomSafeArea);

                position = Offset(newX, newY);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDial(BuildContext context) {
    return SpeedDial(
      shape: const CircleBorder(),
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      buttonSize: Size(65.w, 65.h),
      animatedIcon: AnimatedIcons.add_event,
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
