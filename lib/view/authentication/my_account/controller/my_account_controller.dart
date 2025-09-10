import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_notifications/core/service/app_link.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/core/service/shared_prefrences_keys.dart';
import 'package:todo_app_with_notifications/core/service/user_service.dart';
import 'package:todo_app_with_notifications/data/model/failed_tasks_model.dart';

import '../../../../core/class/crud.dart';
import '../../../../core/const_data/app_animations.dart';
import '../../../../core/const_data/app_colors.dart';
import '../../../../core/const_data/app_strings.dart';
import '../../../../core/service/messages.dart';
import '../../../../core/service/my_service.dart';
import '../../../../core/service/network_manager.dart';
import '../../../../data/local/database_service.dart';
import '../../../../data/model/user_model.dart';
import '../../../tasks/verify_task_completion/screen/animation_screen.dart';

class MyAccountController extends GetxController {
  var failedTasksList = <FailedTaskModel>[];
  Rx<File?> selectedImage = Rx<File?>(null);
  final myService = Get.find<MyService>();
  var isLoader = false.obs;
  final DatabaseService _databaseService = DatabaseService.instance;
  var refreshLoading = false.obs;
  void refreshUser() async {
    refreshLoading.value = true;
    await getUserData();
    await loadFailedTasksFromServer();
    refreshLoading.value = false;
  }

  void updateEmail(String newEmail, String oldEmail) async {
    if (newEmail != oldEmail) {
      Get.to(() => AnimationScreen(
            animationName: AppAnimations.loading,
            analysisText: "",
            isLoading: true,
            isCompleted: false,
          ));
      final Map<String, dynamic> fields = {"email": newEmail};
      // Call your API or update local state here
      await updateUserDetails(
        fields,
        isEmail: true,
        fetchUserData: false,
      );
      Get.back(); // close the dialog only if name changed
      final myService = Get.find<MyService>();
      await myService.clearAllUserData();
      Get.offAllNamed(Routes.loginScreen);
    } else {
      Messages.getSnackMessage(
        'Note'.tr,
        'New username can\'t be the same as old username.'.tr,
        ColorsManager.primary,
      );
      return;
    }
  }

  void updateName(String newName, String oldName) async {
    if (newName != oldName) {
      Get.to(() => AnimationScreen(
            animationName: AppAnimations.loading,
            analysisText: "",
            isLoading: true,
            isCompleted: false,
          ));
      final Map<String, dynamic> fields = {"name": newName};
      // Call your API or update local state here
      await updateUserDetails(
        fields,
        isEmail: false,
        fetchUserData: false,
      );
      Get.back(); // close the dialog only if name changed
      Messages.getSnackMessage(
        'Success'.tr,
        'Username updated successfully!'.tr,
        ColorsManager.green,
      );
      final myService = Get.find<MyService>();
      await myService.clearAllUserData();
      Get.offAllNamed(Routes.loginScreen);
    } else {
      Messages.getSnackMessage(
        'Note'.tr,
        'New username can\'t be the same as old username.'.tr,
        ColorsManager.primary,
      );
      return;
    }
  }

  Future<void> getUserData() async {
    final result = await Crud().getData(AppLink.getUserDetails);

    result.fold(
      (error) async {
        final retry = await Crud().getData(AppLink.getUserDetails);
        retry.fold(
          (retryError) async {
            try {
              final db = await _databaseService.database;
              final userMapList = await db.query(AppStrings.usersTableName);

              if (userMapList.isNotEmpty) {
                final localUser = UserModel.fromMap(userMapList.first);
                Get.find<UserService>().setUser(localUser);
              }
            } catch (e) {
              Messages.getSnackMessage(
                "Error".tr,
                e.toString().tr,
                ColorsManager.primary,
              );
            }
          },
          (data) {
            final user = UserModel.fromMap(data);
            Get.find<UserService>().setUser(user);
          },
        );
      },
      (data) {
        // ✅ Fetched from server — update user service
        try {
          final user = UserModel.fromMap(data);
          Get.find<UserService>().setUser(user);
        } catch (e) {
          Messages.getSnackMessage(
            "Error".tr,
            e.toString().tr,
            ColorsManager.primary,
          );
        }
      },
    );
  }

  Future<void> updateUserDetails(
    Map<String, dynamic> fields, {
    required bool isEmail,
    bool fetchUserData = true,
  }) async {
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().putData(
          AppLink.updateUserDetails,
          fields,
          AppLink().getHeaderToken(),
        );

        result.fold((error) {
          Messages.getSnackMessage(
            "Error".tr,
            "Failed to update user".tr,
            ColorsManager.primary,
          );
        }, (responseBody) async {
          final db = await _databaseService.database;
          final userId = Get.find<UserService>().currentUser!.id;

          await db.update(
            AppStrings.usersTableName,
            fields,
            where: '${AppStrings.usersIdColumnName} = ?',
            whereArgs: [userId],
          );
          if (isEmail) {
            Messages.getSnackMessage(
              'Success'.tr,
              responseBody['message'].tr,
              ColorsManager.green,
            );
          }
        });
        if (fetchUserData) {
          await getUserData();
        }
      } else {
        Messages.getSnackMessage(
            "No Internet".tr,
            "Check your connection and try again later.".tr,
            ColorsManager.grey);
      }
    } catch (e) {
      Messages.getSnackMessage(
        "Error".tr,
        e.toString(),
        ColorsManager.primary,
      );
    }
  }

// load failed tasks when the user open's up the my account screen
  Future<void> loadFailedTasksFromServer() async {
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().getData(AppLink.getFailedTasks);

        result.fold(
          (error) {
            Messages.getSnackMessage(
              'Something went wrong'.tr,
              'Loading Tasks from local Database.'.tr,
              ColorsManager.grey,
            );
            loadFailedTasksFromLocalDB();
          },
          (responseBody) async {
            if (responseBody is List) {
              // 1. Clear local DB
              final db = await _databaseService.database;
              await db.delete(AppStrings.failedTasksTableName);

              // 2. Insert new tasks into local DB and into memory list
              failedTasksList.clear();
              for (var failedTaskMap in responseBody) {
                try {
                  final task = FailedTaskModel.fromMap(
                    Map<String, dynamic>.from(failedTaskMap),
                  );

                  failedTasksList.add(task); // add to in-memory list
                  await db.insert(
                    AppStrings.failedTasksTableName,
                    task.toMap(),
                    conflictAlgorithm: ConflictAlgorithm.replace,
                  );
                } catch (e) {
                  Messages.getSnackMessage(
                    'Something went wrong'.tr,
                    "Check your connection and try again later.".tr,
                    ColorsManager.grey,
                  );
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
              loadFailedTasksFromLocalDB();
            }
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Loading Tasks from local Database.'.tr,
          ColorsManager.grey,
        );
        loadFailedTasksFromLocalDB();
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
      loadFailedTasksFromLocalDB();
    }
  }

  void loadFailedTasksFromLocalDB() async {
    final db = await _databaseService.database;
    final data = await db.query(AppStrings.tasksTableName);
    failedTasksList.clear();
    for (var value in data) {
      failedTasksList.add(FailedTaskModel.fromMap(value));
    }
    update();
  }

  Future<void> logout() async {
    isLoader.value = true;
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().postData(
          AppLink.logout,
          {},
          AppLink().getHeaderToken(),
          false,
        );
        await result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            if (responseBody["message"] != null) {
              Messages.getSnackMessage(
                "Success".tr,
                responseBody["message"].tr,
                ColorsManager.green,
              );
            }
            final myService = Get.find<MyService>();
            await myService.clearAllUserData();
            Get.offAllNamed(Routes.loginScreen);
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          "Check your connection and try again later.".tr,
          ColorsManager.primary,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    } finally {
      isLoader.value = false;
    }
  }

  Future<void> pickImage() async {
    PermissionStatus status = await Permission.photos.status;

    if (Platform.isAndroid) {
      status = await Permission.storage.status; // for Android <13
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.status; // for iOS or Android 13+
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
    }

    if (!status.isGranted) {
      status = await Permission.photos.request();

      Messages.getSnackMessage(
        'Permission Denied'.tr,
        'You need to allow gallery access to pick an image.'.tr,
        ColorsManager.primary,
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    selectedImage.value = File(pickedFile.path);

    // Save path to SharedPreferences
    await myService.storeStringData(
        SharedPrefrencesKeys.profileImagePath, pickedFile.path);
  }
}
