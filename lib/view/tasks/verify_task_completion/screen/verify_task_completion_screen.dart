import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import '../../../../data/model/task_model.dart';
import '../controller/verify_task_completion_controller.dart';

class VerifyTaskCompletionScreen extends StatelessWidget {
  const VerifyTaskCompletionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final TaskModel task = Get.arguments as TaskModel;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Verify Task Completion".tr,
        style: TextStyles.headingTextStyle(context).copyWith(fontSize: 27.sp),
      )),
      body: GetBuilder<VerifyTaskCompletionController>(
        init: VerifyTaskCompletionController(),
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              children: [
                // Title
                Text(
                  "Upload Image of Completed Task".tr,
                  style: TextStyles.bodyTextStyle(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 25.h),

                // Pick Image Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.pickImage,
                    icon: Icon(Icons.image_outlined,
                        color: isDark ? Colors.black : Colors.white,
                        size: 30.r),
                    label: Text(
                      "Pick Image".tr,
                      style: TextStyles.smallTextStyle(context).copyWith(
                          color: isDark ? Colors.black : Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // Image Display
                controller.selectedImage != null
                    ? Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(controller.selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Text(
                          "No image selected.".tr,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),

                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.selectedImage != null
                        ? () => controller.sendImageWithQuestion(task)
                        : null,
                    icon: Icon(Icons.send_rounded,
                        color: ColorsManager.white, size: 30.r),
                    label: Text(
                      "Submit for Verification".tr,
                      style: TextStyles.smallTextStyle(context).copyWith(
                        color: ColorsManager.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: ColorsManager.green,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
