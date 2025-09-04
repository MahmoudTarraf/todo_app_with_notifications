import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_notifications/core/class/crud.dart';
import 'package:todo_app_with_notifications/core/class/status_request.dart';
import 'package:todo_app_with_notifications/core/const_data/app_strings.dart';
import 'package:todo_app_with_notifications/core/service/messages.dart';
import 'package:todo_app_with_notifications/core/service/network_manager.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/data/local/database_service.dart';
import 'package:todo_app_with_notifications/data/model/notes_model.dart';

import '../../../core/const_data/app_colors.dart';
import '../../../core/service/app_link.dart';

class NotesController extends GetxController {
  final notesList = <NotesModel>[];
  final _databaseService = DatabaseService.instance;
  StatusRequest statusRequest = StatusRequest.none;
  bool isLoading = false;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  Rx<DateTime?> selectedDeadline = Rx<DateTime?>(null);
  RxString priority = ''.obs;

  NotesController() {
    loadNotes(); // runs once when controller is created
  }

  Future<void> refreshNotes() async {
    await loadNotes();
  }

  void createNoteToAdd() async {
    final title = titleController.text;
    final content = contentController.text;

    if (title.isNotEmpty & content.isNotEmpty) {
      final Map<String, dynamic> note = {"title": title, "content": content};
      await addNote(note);
    } else {
      Messages.getSnackMessage(
          "Note".tr,
          'Content can\'t be empty.\nTitle can\'t be empty.'.tr,
          ColorsManager.primary);
      return;
    }
  }

  // 🔹 Load Notes (Server -> Local -> UI)
  Future<void> loadNotes() async {
    isLoading = true;
    update();
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().getData(AppLink.getNotes);

        result.fold(
          (error) {
            loadNotesFromLocalDB();
          },
          (responseBody) async {
            if (responseBody is List) {
              // 1. Clear local DB
              final db = await _databaseService.database;
              await db.delete(AppStrings.notesTableName);

              // 2. Insert into local DB + memory list
              notesList.clear();
              for (var noteMap in responseBody) {
                final note = NotesModel.fromMap(noteMap);
                notesList.add(note);
                await db.insert(
                  AppStrings.notesTableName,
                  note.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              }

              update();
            } else {
              loadNotesFromLocalDB();
            }
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Loading Notes from local database.'.tr,
          Colors.grey,
        );
        loadNotesFromLocalDB();
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), Colors.red);
      loadNotesFromLocalDB();
    } finally {
      isLoading = false;
      update();
    }
  }

  // 🔹 Add Note
  Future<void> addNote(Map<String, dynamic> note) async {
    try {
      statusRequest = StatusRequest.loading;
      update();
      if (await NetworkManager().isOnline()) {
        statusRequest = StatusRequest.loading;
        update();

        final result = await Crud()
            .postData(AppLink.addNote, note, AppLink().getHeaderToken(), false);

        result.fold(
          (error) {
            statusRequest = StatusRequest.error;
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              Colors.red,
            );
          },
          (responseBody) async {
            statusRequest = StatusRequest.success;
            update();
            Messages.getSnackMessage(
              "Success".tr,
              "Note added successfully".tr,
              Colors.green,
            );

            final serverId = responseBody['id'];

            if (serverId != null) {
              note['id'] = serverId;
            }

            final db = await _databaseService.database;
            await db.insert(AppStrings.notesTableName, note);

            loadNotes();
            Get.toNamed(Routes.notesScreen);
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Please check your connection and try again.'.tr,
          Colors.red,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), Colors.red);
    } finally {
      statusRequest = StatusRequest.none;
      update();
    }
  }

  // 🔹 Update Note
  Future<void> updateNote(int? noteId) async {
    final String title = titleController.text.trim();
    final String content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      Messages.getSnackMessage(
        "Note".tr,
        'Content can\'t be empty.\nTitle can\'t be empty.'.tr,
        ColorsManager.primary,
      );
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    try {
      if (await NetworkManager().isOnline()) {
        final Map<String, dynamic> updatedNote = {
          AppStrings.notesIdColumnName: noteId, // keep the note id
          AppStrings.notesTitleColumnName: title,
          AppStrings.notesContentColumnName: content,
        };

        final result = await Crud().putData(
          "${AppLink.updateNote}/$noteId", // send correct id in URL
          updatedNote, // send new values
          AppLink().getHeaderToken(),
        );

        result.fold(
          (error) {
            statusRequest = StatusRequest.error;
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              Colors.red,
            );
          },
          (responseBody) async {
            statusRequest = StatusRequest.success;
            update();

            Messages.getSnackMessage(
              "Success".tr,
              "Note updated successfully".tr,
              Colors.green,
            );

            // 🔹 Update locally (SQLite)
            final db = await _databaseService.database;
            await db.update(
              AppStrings.notesTableName,
              updatedNote,
              where: '${AppStrings.notesIdColumnName} = ?',
              whereArgs: [noteId],
            );

            // 🔹 Refresh list in controller
            await loadNotes();

            // 🔹 Replace screen instead of stacking
            Get.offNamed(Routes.notesScreen);
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Please check your connection and try again.'.tr,
          Colors.red,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), Colors.red);
    } finally {
      statusRequest = StatusRequest.none;
      update();
    }
  }

  // 🔹 Delete Note
  void deleteNote(int noteId) async {
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().deleteData(
          "${AppLink.deleteNote}/$noteId",
          AppLink().getHeaderToken(),
        );

        result.fold(
          (error) {
            statusRequest = StatusRequest.error;
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              Colors.red,
            );
          },
          (responseBody) async {
            Messages.getSnackMessage(
              "Success".tr,
              "Note deleted successfully".tr,
              Colors.green,
            );

            final db = await _databaseService.database;
            await db.delete(
              AppStrings.notesTableName,
              where: '${AppStrings.notesIdColumnName} = ?',
              whereArgs: [noteId],
            );

            loadNotes();
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Please check your connection and try again.'.tr,
          Colors.red,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), Colors.red);
    }
  }

  // 🔹 Load Notes only from Local DB
  void loadNotesFromLocalDB() async {
    final db = await _databaseService.database;
    final data = await db.query(AppStrings.notesTableName);
    notesList.clear();
    for (var value in data) {
      notesList.add(NotesModel.fromMap(value));
    }
    update();
  }

  @override
  void onClose() {
    titleController.clear();
    contentController.clear();
    super.onClose();
  }
}
