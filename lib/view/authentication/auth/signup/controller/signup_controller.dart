import 'package:get/get.dart';
import '../../../../../core/class/crud.dart';
import '../../../../../core/class/status_request.dart';
import '../../../../../core/const_data/app_colors.dart';
import '../../../../../core/service/app_link.dart';
import '../../../../../core/service/messages.dart';
import '../../../../../core/service/routes.dart';

class SignupController extends GetxController {
  bool isPasswordVisible = false;
  bool isPasswordAgainVisible = false;
  StatusRequest statusRequest = StatusRequest.none;
  String _name = '';
  String _email = '';
  String _password = '';
  String get getPassword => _password;
// setters
  void setName(String name) {
    _name = name;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  // Toggling password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void togglePasswordAgainVisibility() {
    isPasswordAgainVisible = !isPasswordAgainVisible;
    update();
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

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty'.tr;
    }
    if (value != _password) {
      return 'Passwords don\'t match!'.tr;
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

  //  Sign Up Logic
  Future<void> signUp() async {
    try {
      String name = _name.trim();
      String email = _email.trim();
      String password = _password.trim();
      Map<String, String> fields = {
        'name': name,
        'email': email,
        'password': password,
      };
      statusRequest = StatusRequest.loading;
      update();

      // ConstData.token = await _firebaseMessaging.getToken() ?? '';
      final result = await Crud().postData(
        AppLink.register,
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
          Messages.getSnackMessage(
            'Success'.tr,
            'Account created! Please verify your email.'.tr,
            ColorsManager.green,
          );
          Get.toNamed(Routes.loginScreen);
        },
      );
    } catch (e) {
      statusRequest = StatusRequest.serverFailure; // General failure status

      Messages.getSnackMessage(
          'Error'.tr, e.toString().tr, ColorsManager.primary);
    } finally {
      statusRequest = StatusRequest.none;
      update();
    }
  }
}
