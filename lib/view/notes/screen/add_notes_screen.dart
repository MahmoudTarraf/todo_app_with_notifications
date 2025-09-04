// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/view/notes/controller/notes_controller.dart';
import 'package:todo_app_with_notifications/widgets/custom_app_bar.dart';

import '../../../core/class/status_request.dart';
import '../../../core/const_data/text_styles.dart';

class AddNotesScreen extends StatelessWidget {
  final NotesController controller = Get.put(
    NotesController(),
    permanent: true,
  );

  AddNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: "Add Note".tr.tr),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: theme.dividerColor, // ✅ dynamic border
                  ),
                  color:
                      theme.cardColor.withOpacity(0.7), // ✅ dynamic background
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
                  style: TextStyle(
                    fontSize: 18.sp,
                    color:
                        theme.textTheme.bodyLarge?.color, // ✅ adapts text color
                  ),
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
                      color: theme.dividerColor, // ✅ dynamic border
                    ),
                    color: theme.cardColor
                        .withOpacity(0.7), // ✅ dynamic background
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: TextField(
                      controller: controller.contentController,
                      decoration: InputDecoration(
                        labelText: "Content".tr,
                        labelStyle: TextStyle(fontSize: 20.sp),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color:
                            theme.textTheme.bodyLarge?.color, // ✅ dynamic text
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100.h),
              GetBuilder<NotesController>(
                builder: (controller) {
                  return controller.statusRequest == StatusRequest.loading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              controller.createNoteToAdd();
                            },
                            icon: Icon(
                              Icons.add,
                              size: 30.r,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                            label: Text(
                              'Add Note'.tr,
                              style:
                                  TextStyles.smallTextStyle(context).copyWith(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
