import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';
import 'package:todo_app_with_notifications/data/model/notes_model.dart';
import 'package:todo_app_with_notifications/view/notes/controller/notes_controller.dart';
import 'package:todo_app_with_notifications/view/notes/screen/update_notes_screen.dart';

import '../../../../core/const_data/text_styles.dart';

// ignore: must_be_immutable
class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    required this.note,
    required this.controller,
  });
  final NotesModel note;
  final NotesController controller;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
          ),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("What would you like to do?".tr,
                      style: TextStyles.headingTextStyle(context)),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Get.to(
                            () => UpdateNotesScreen(
                              note: note,
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context); // close dialog
                        },
                        icon: const Icon(Icons.edit),
                        label: Text("Update".tr),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'.tr),
                              content: Text(
                                'Are you sure you want to delete this Note?'.tr,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'.tr),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.deleteNote(note.id!);
                                    Navigator.pop(context); // close dialog
                                    Navigator.pop(
                                        context); // close bottom sheet
                                  },
                                  child: Text(
                                    'Delete'.tr,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: ColorsManager.white,
                          size: 25.r,
                        ),
                        label: Text("Delete".tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Title & Priority Icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyles.bodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // 📝 Content (optional)
              Text(
                note.content,
                style: TextStyles.bodyTextStyle(context),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
