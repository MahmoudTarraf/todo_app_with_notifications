import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_notifications/core/class/crud.dart';
import 'package:todo_app_with_notifications/core/service/app_link.dart';
import 'package:todo_app_with_notifications/core/service/network_manager.dart';
import 'package:todo_app_with_notifications/core/service/user_service.dart';
import 'package:todo_app_with_notifications/view/achievments/controller/achievments_controller.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/controller/my_account_controller.dart';

import '../../../../core/class/status_request.dart';
import '../../../../core/const_data/app_colors.dart';
import '../../../../core/const_data/app_strings.dart';
import '../../../../core/service/routes.dart';
import '../../../../data/local/database_service.dart';
import '../../../../core/service/messages.dart';
import '../../../../data/model/task_model.dart';

class IncompleteTasksController extends GetxController {
  var taskList = <TaskModel>[];
  bool isLoading = false;
  final DatabaseService _databaseService = DatabaseService.instance;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  // final notificationService = NotificationService.instance;
  IncompleteTasksController() {
    loadTasks();
  }

  Future<void> refreshTasks() async {
    await loadTasks();
  }

  Future<void> loadTasks() async {
    isLoading = true;
    update();
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().getData(AppLink.getTasks);

        result.fold(
          (error) {
            Messages.getSnackMessage(
              'Something went wrong'.tr,
              'Loading Tasks from local Database.'.tr,
              ColorsManager.grey,
            );
            loadTasksFromLocalDB();
          },
          (responseBody) async {
            if (responseBody is List) {
              // 1. Clear local DB
              final db = await _databaseService.database;
              await db.delete(AppStrings.tasksTableName);

              // 2. Insert new tasks into local DB and into memory list
              taskList.clear();
              for (var taskMap in responseBody) {
                try {
                  final task = TaskModel.fromMap(taskMap);

                  taskList.add(task);
                  await db.insert(
                    AppStrings.tasksTableName,
                    task.toMap(),
                    conflictAlgorithm: ConflictAlgorithm.replace,
                  );
                } catch (e) {
                  rethrow;
                }
              }

              // 3. Update UI
              update();
            } else {
              Messages.getSnackMessage(
                'Something went wrong'.tr,
                'Loading Tasks from local Database.'.tr,
                ColorsManager.grey,
              );
              loadTasksFromLocalDB();
            }
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Loading Tasks from local Database.'.tr,
          ColorsManager.grey,
        );
        loadTasksFromLocalDB();
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
      loadTasksFromLocalDB();
    } finally {
      isLoading = false;
      update();
    }
  }

// first check for internet access then upload to server then to local DB
  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      if (await NetworkManager().isOnline()) {
        statusRequest.value = StatusRequest.loading;
        final fcmToken = await FirebaseMessaging.instance.getToken();
        task['fcmToken'] = fcmToken;

        final result = await Crud()
            .postData(AppLink.addTask, task, AppLink().getHeaderToken(), false);
        result.fold(
          (error) {
            statusRequest.value =
                StatusRequest.error; // Update with error status

            statusRequest.value = StatusRequest.error;
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr, // fallback if null
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            statusRequest.value = StatusRequest.success;
            Messages.getSnackMessage(
              "Success".tr,
              "Task added Successfully!",
              ColorsManager.green,
            );
            final serverId = responseBody['id'];
            if (serverId != null) {
              task['id'] = serverId;
            }

            final db = await _databaseService.database;

            final localTask = Map<String, dynamic>.from(task);
            localTask.remove('fcmToken');

            // ✅ Ensure dates are stored as JSON string, not List
            if (localTask['dates'] is List) {
              localTask['dates'] = jsonEncode(localTask['dates']);
            }

            await db.insert(
              AppStrings.tasksTableName,
              localTask,
            );

            await loadTasks();
            Get.offNamed(Routes.incompleteTasksScreen);
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Please check your connection and try again.'.tr,
          ColorsManager.primary,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    } finally {
      statusRequest.value = StatusRequest.none;
    }
  }

  Future<void> updateTask(
      TaskModel task, bool changeUserRemainingUpdates) async {
    //! update task on server by id then update the task locally and make sure to do: remainingUpdates - 1 or if the user completed the task then just update te state and do not subtract 1 from remainingUpdates.

    try {
      if (await NetworkManager().isOnline()) {
        statusRequest.value = StatusRequest.loading;
        final result = await Crud().putData(
          "${AppLink.updateTask}/${task.id}",
          task.toMap(),
          AppLink().getHeaderToken(),
        );
        result.fold(
          (error) {
            statusRequest.value =
                StatusRequest.error; // Update with error status

            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr, // fallback if null
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            statusRequest.value = StatusRequest.success;

            Messages.getSnackMessage(
              "Success".tr,
              "Task updated Successfully!".tr,
              ColorsManager.green,
            );
            if (changeUserRemainingUpdates) {
              final remainingUpdates =
                  Get.find<UserService>().currentUser!.remainingUpdates;
              final Map<String, dynamic> fields = {
                "remainingUpdates": remainingUpdates - 1
              };
              final myAccountController = Get.put(MyAccountController());
              await myAccountController.updateUserDetails(fields,
                  isEmail: false);
            }

            // update task locally
            final db = await _databaseService.database;

            await db.update(
              AppStrings.tasksTableName,
              task.toMap(),
              where: '${AppStrings.tasksIdColumnName} = ?',
              whereArgs: [task.id],
            );
            await loadTasks();
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Please check your connection and try again.'.tr,
          ColorsManager.primary,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    } finally {
      statusRequest.value = StatusRequest.none;
    }
  }

  void deleteTask(int taskId) async {
    //! delete task on server by id then delete the task locally and make sure to do: remainingDeletes - 1

    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().deleteData(
          "${AppLink.deleteTask}/$taskId",
          AppLink().getHeaderToken(),
        );
        result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr, // fallback if null
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            Messages.getSnackMessage(
              "Success".tr,
              "Task updated Successfully!".tr,
              ColorsManager.green,
            );
            final remainingDeletes =
                Get.find<UserService>().currentUser!.remainingDeletes;
            final Map<String, dynamic> fields = {
              "remainingDeletes": remainingDeletes - 1
            };
            final myAccountController = Get.put(MyAccountController());
            await myAccountController.updateUserDetails(fields, isEmail: false);
            // delete task locally
            final db = await _databaseService.database;

            await db.delete(
              AppStrings.tasksTableName,
              where: '${AppStrings.tasksIdColumnName} = ?',
              whereArgs: [taskId],
            );

            await loadTasks();
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Please check your connection and try again.'.tr,
          ColorsManager.primary,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    }
  }

  Future<void> markTaskAsCompleted(TaskModel task) async {
    final controller = Get.put(AchievementsController());
    task.isCompleted = true;
    await updateTask(task, false);
    await controller.checkAchievements();
    update();
  }

  void loadTasksFromLocalDB() async {
    final db = await _databaseService.database;
    final data = await db.query(AppStrings.tasksTableName);
    taskList.clear();
    for (var value in data) {
      taskList.add(TaskModel.fromMap(value));
    }
    update();
  }
}
