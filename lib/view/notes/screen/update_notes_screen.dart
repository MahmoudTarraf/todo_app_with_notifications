// 📁 update_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/data/model/notes_model.dart';
import 'package:todo_app_with_notifications/view/notes/controller/notes_controller.dart';

class UpdateNotesScreen extends StatelessWidget {
  final NotesModel note;

  const UpdateNotesScreen({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Note'.tr,
            style: TextStyles.headingTextStyle(context),
          ),
        ),
        body: GetBuilder<NotesController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: theme.dividerColor,
                      ),
                      // ignore: deprecated_member_use
                      color: theme.cardColor.withOpacity(0.7),
                    ),
                    child: TextField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 20.sp),
                        labelText: "Title".tr,
                        prefixIcon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      style: TextStyles.bodyTextStyle(context),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: theme.dividerColor,
                        ),
                        // ignore: deprecated_member_use
                        color: theme.cardColor.withOpacity(0.7),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: TextField(
                          controller: controller.contentController,
                          decoration: InputDecoration(
                            labelText: "Content".tr,
                            labelStyle: TextStyle(fontSize: 20.sp),

                            floatingLabelBehavior: FloatingLabelBehavior
                                .always, // keeps label at top
                          ),
                          style: TextStyles.bodyTextStyle(context),

                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical:
                              TextAlignVertical.top, // start typing from top
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  controller.statusRequest == StatusRequest.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              controller.updateNote(note.id);
                            },
                            icon: Icon(
                              Icons.update,
                              color: isDark ? Colors.black : Colors.white,
                              size: 30.r,
                            ),
                            label: Text(
                              'Update Note'.tr,
                              style:
                                  TextStyles.smallTextStyle(context).copyWith(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
