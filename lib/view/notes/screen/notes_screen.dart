import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/core/const_data/app_images.dart';
import 'package:todo_app_with_notifications/core/const_data/text_styles.dart';
import 'package:todo_app_with_notifications/data/model/notes_model.dart';

import 'package:todo_app_with_notifications/widgets/floating_action_button_widget.dart';

import '../controller/notes_controller.dart';
import 'notes_card.dart';

class NotesScreen extends StatelessWidget {
  NotesScreen({super.key});
  final NotesController notesController = Get.put(
    NotesController(),
    permanent: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // centers the title
        title: Text(
          'My Notes'.tr,
          style: TextStyles.headingTextStyle(context),
        ),
        actions: [
          GetBuilder<NotesController>(
            builder: (controller) {
              return IconButton(
                icon: notesController.isLoading
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
                onPressed:
                    notesController.statusRequest == StatusRequest.loading
                        ? null
                        : () => notesController.refreshNotes(),
              );
            },
          ),
        ],
      ),
      body: GetBuilder<NotesController>(builder: (controller) {
        final thisList = controller.notesList;
        return thisList.isEmpty
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
                      "🎉 ${"No Notes here!".tr} \n${'Tap the button and start adding notes.'.tr}",
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
                itemCount: thisList.length,
                itemBuilder: (context, index) {
                  NotesModel note = thisList[index];
                  return NotesCard(
                    controller: controller,
                    note: note,
                  );
                },
              );
      }),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ✅ always bottom right
      floatingActionButton: FloatingActionButtonWidget(),
    );
  }
}
