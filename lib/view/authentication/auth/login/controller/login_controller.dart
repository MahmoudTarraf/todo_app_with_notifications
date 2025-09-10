import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';
import 'package:todo_app_with_notifications/core/service/messages.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/core/service/shared_prefrences_keys.dart';

import '../../../../../core/class/crud.dart';
import '../../../../../core/class/status_request.dart';
import '../../../../../core/const_data/app_strings.dart';
import '../../../../../core/service/app_link.dart';
import '../../../../../core/service/my_service.dart';
import '../../../../../core/service/user_service.dart';
import '../../../../../data/local/database_service.dart';
import '../../../../../data/model/user_model.dart';

class LoginController extends GetxController {
  bool isPasswordVisible = false;
  StatusRequest statusRequest = StatusRequest.none;
  final DatabaseService _databaseService = DatabaseService.instance;

  String _email = '';
  String _password = '';

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  // Validators
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty'.tr;
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty'.tr;
    }
    if (value.length < 6) {
      return 'Weak Password! Must be at least 6 characters'.tr;
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty'.tr;
    }
    if (!value.contains('@')) {
      return 'Not a valid email!'.tr;
    }
    return null;
  }

  // Form validation and submission
  void verify(var key) async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      await login();
    }
  }

  // Toggling password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  // login Logic
  Future<void> login() async {
    try {
      String email = _email.trim();
      String password = _password.trim();
      Map<String, String> fields = {
        'email': email,
        'password': password,
      };
      statusRequest = StatusRequest.loading;
      update();
      final result = await Crud().postData(
        AppLink.login,
        fields,
        AppLink().getHeader(),
        true,
        isFormData: false,
      );

      // Handling response
      result.fold(
        (error) {
          statusRequest = StatusRequest.error; // Update with error status

          statusRequest = StatusRequest.error;
          Messages.getSnackMessage(
            "Error".tr,
            error.message ?? "Something went wrong".tr, // fallback if null
            ColorsManager.primary,
          );
        },
        (responseBody) async {
          statusRequest = StatusRequest.success;

          final userModel = UserModel.fromMap((responseBody['user']));
          Get.find<UserService>().setUser(userModel);
          await saveLoginInfo(userModel);
          // Show success toast and navigate to login screen
          Messages.getSnackMessage(
            'Success'.tr,
            'Welcome to Tasker!'.tr,
            ColorsManager.green,
          );
          Get.offAllNamed(Routes.splashScreen); // Navigate to login screen
        },
      );
    } catch (e) {
      statusRequest = StatusRequest.serverFailure; // General failure status
      update();
      Messages.getSnackMessage('Error'.tr, e.toString().tr, Colors.red);
    } finally {
      statusRequest = StatusRequest.none;
      update();
    }
  }

  Future<void> saveLoginInfo(UserModel usermodel) async {
    final myService = Get.find<MyService>();
    await myService.storeBoolData(SharedPrefrencesKeys.isLoginKey, true);

    final db = await _databaseService.database;

    // 🧹 Clear any previous user info
    await db.delete(AppStrings.usersTableName);

    // 💾 Insert the new user
    await db.insert(
      AppStrings.usersTableName,
      usermodel.toMap(),
    );
  }
}
