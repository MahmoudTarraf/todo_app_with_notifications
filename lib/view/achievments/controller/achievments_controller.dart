import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_notifications/view/home/controller/home_controller.dart';

import '../../../core/class/crud.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/app_strings.dart';
import '../../../core/service/app_link.dart';
import '../../../core/service/messages.dart';
import '../../../core/service/network_manager.dart';
import '../../../core/service/user_service.dart';
import '../../../data/local/database_service.dart';
import '../../../data/model/achievments_model.dart';

class AchievementsController extends GetxController {
  final userService = Get.find<UserService>();
  final DatabaseService _databaseService = DatabaseService.instance;

  /// reactive list for UI
  var achievementsList = <AchievementsModel>[].obs;

  /// loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final id = userService.currentUser?.id;
    if (id != null) {
      getAchievements(id);
    }
  }

  /// manually refresh achievements
  Future<void> refreshAchievements() async {
    final id = userService.currentUser?.id;
    if (id != null) {
      await getAchievements(id);
      await Get.find<HomeController>().getHomeData();
    }
  }

  /// fetch achievements from API or fallback to local
  Future<void> getAchievements(int userId) async {
    try {
      isLoading.value = true;

      if (await NetworkManager().isOnline()) {
        final result = await Crud().getData(
          "${AppLink.users}/$userId/getAchievements",
        );

        await result.fold(
          (error) async {
            Messages.getSnackMessage(
              "Error".tr,
              error.message ?? "Something went wrong".tr,
              ColorsManager.primary,
            );
            await loadAchievementsFromLocalDB();
          },
          (responseBody) async {
            final db = await _databaseService.database;
            await db.delete(AppStrings.achievementsTableName);

            final list = (responseBody as List)
                .map((item) => AchievementsModel.fromMap(item))
                .toList();

            achievementsList.assignAll(list);
            await insertAchievementsIntoDB(responseBody);
          },
        );
      } else {
        await loadAchievementsFromLocalDB();
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Loaded achievements from offline storage.'.tr,
          ColorsManager.primary,
        );
      }
    } catch (e) {
      await loadAchievementsFromLocalDB();
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    } finally {
      isLoading.value = false;
    }
  }

  /// tells backend to check/update user achievements
  Future<void> checkAchievements() async {
    final userId = userService.currentUser!.id;
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().postData(
          "${AppLink.users}/$userId/check-achievements",
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
                "Achievements",
                responseBody["message"],
                ColorsManager.green,
              );
            }
            if (responseBody["achievements"] != null) {
              await insertAchievementsIntoDB(
                responseBody["achievements"] as List<dynamic>,
              );
            }
            await getAchievements(userId);
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'checkInternet'.tr,
          ColorsManager.primary,
        );
      }
    } catch (e) {
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
    }
  }

  /// insert achievements into local DB
  Future<void> insertAchievementsIntoDB(List<dynamic> responseBody) async {
    final db = await _databaseService.database;
    for (var ach in responseBody) {
      await db.insert(
        AppStrings.achievementsTableName,
        {
          "id": ach["id"],
          "title": ach["title"],
          "subTitle": ach["subTitle"],
          "condition": ach["condition"],
          "isCompleted": ach["isCompleted"] ? 1 : 0,
          "achievedAt": ach["achievedAt"] ?? "N/A",
          "progress": ach["progress"] ?? 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// load from local DB
  Future<void> loadAchievementsFromLocalDB() async {
    final db = await _databaseService.database;
    final data = await db.query(AppStrings.achievementsTableName);

    final list = data.map((e) => AchievementsModel.fromMap(e)).toList();
    achievementsList.assignAll(list);
  }
}
