import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/crud.dart';
import '../../core/class/status_request.dart';
import '../../core/const_data/app_colors.dart';
import '../../core/service/app_link.dart';
import '../../core/service/messages.dart';
import '../model/task_model.dart';

// ! not used
class TaskApiService extends GetxController {
  StatusRequest statusRequest = StatusRequest.none;

  Future<void> createTask(TaskModel task) async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      Map<String, dynamic> fields = task.toMap(); // assume this exists

      final result = await Crud().postData(
        AppLink.addTask,
        fields,
        AppLink().getHeader(),
        true,
        isFormData: false,
      );

      result.fold(
        (error) {
          statusRequest = StatusRequest.error;
          Messages.getSnackMessage(
            "Error",
            error.message ?? "Something went wrong", // fallback if null
            ColorsManager.primary,
          );
        },
        (response) {
          statusRequest = StatusRequest.success;
          Messages.getSnackMessage(
            'Success',
            'Task Created Successfully',
            ColorsManager.green,
          );
        },
      );
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      Messages.getSnackMessage("Exception", e.toString(), Colors.red);
    } finally {
      update();
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      Map<String, dynamic> fields = task.toMap();

      final result = await Crud().postData(
        AppLink.updateTask,
        fields,
        AppLink().getHeader(),
        true,
        isFormData: false,
      );

      result.fold(
        (error) {
          statusRequest = StatusRequest.error;
          Messages.getSnackMessage(
            "Error",
            error.message ?? "Something went wrong", // fallback if null
            ColorsManager.primary,
          );
        },
        (response) {
          statusRequest = StatusRequest.success;
          Messages.getSnackMessage(
            'Success',
            'Task Updated Successfully',
            ColorsManager.green,
          );
        },
      );
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      Messages.getSnackMessage(
        "Error",
        e.toString(), // fallback if null
        ColorsManager.primary,
      );
    } finally {
      update();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      final result = await Crud().postData(
        AppLink.deleteTask,
        {'id': id.toString()},
        AppLink().getHeader(),
        true,
        isFormData: false,
      );

      result.fold(
        (error) {
          statusRequest = StatusRequest.error;
          Messages.getSnackMessage(
            "Error",
            error.message ?? "Something went wrong", // fallback if null
            ColorsManager.primary,
          );
        },
        (response) {
          statusRequest = StatusRequest.success;
          Messages.getSnackMessage(
            'Success',
            'Task Deleted Successfully',
            ColorsManager.green,
          );
        },
      );
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      Messages.getSnackMessage(
        "Error",
        e.toString(), // fallback if null
        ColorsManager.primary,
      );
    } finally {
      update();
    }
  }
}
