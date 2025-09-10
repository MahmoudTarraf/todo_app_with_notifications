import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/shared_prefrences_keys.dart';
import '../../../core/class/crud.dart';
import '../../../core/const_data/app_animations.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/service/app_link.dart';
import '../../../core/service/messages.dart';
import '../../../core/service/my_service.dart';
import '../../../core/service/network_manager.dart';
import '../../../widgets/congrats_screen.dart';

class HomeController extends GetxController {
  int selectedIndex = 2;
  var tasksDueToday = 0.obs;
  var tasksCompleted = 0.obs;
  var streak = 0.obs;
  var upcomingTaskCount = 0.obs;
  var upcomingTaskText = ''.obs;

  @override
  void onInit() {
    getHomeData();
    super.onInit();
  }

  updateIndex(int value) {
    selectedIndex = value;
    update();
  }

  Future<void> getHomeData() async {
    try {
      if (await NetworkManager().isOnline()) {
        final result = await Crud().getData(AppLink.getHomeData);

        result.fold(
          (error) {
            Messages.getSnackMessage(
              "Error".tr,
              error.toString().tr,
              ColorsManager.primary,
            );
          },
          (responseBody) async {
            tasksDueToday.value = responseBody['tasksDueToday'] ?? 0;
            tasksCompleted.value = responseBody['tasksCompleted'] ?? 0;
            streak.value = responseBody['streak'] ?? 0;
            upcomingTaskCount.value = responseBody['upcomingTaskCount'] ?? 0;

            // Reset text in case no deadline
            upcomingTaskText.value = '';
            // 🎯 Check if reward exists
            final myService = Get.find<MyService>();
            final lastShownStreak =
                myService.getIntData(SharedPrefrencesKeys.lastShownStreak) ?? 0;
            if (responseBody['reward'] != null &&
                streak.value > lastShownStreak) {
              Get.to(() => CongratsScreen(
                    animationName: AppAnimations.congratulations,
                    streak: streak.value,
                  ));
              await myService.storeIntData(
                  SharedPrefrencesKeys.lastShownStreak, streak.value);
            }
            final deadline = responseBody['nextDeadline'];
            if (deadline != null && deadline.toString().isNotEmpty) {
              final nextDate = DateTime.tryParse(deadline);
              if (nextDate != null) {
                final diff = nextDate.difference(DateTime.now());
                final hours = diff.inHours;
                final minutes = diff.inMinutes % 60;

                String timeText = '';
                if (hours > 0) {
                  timeText += Get.locale?.languageCode == 'ar'
                      ? '$hours ساعة '
                      : '$hours hour${hours > 1 ? 's' : ''} ';
                }
                if (minutes > 0) {
                  timeText += Get.locale?.languageCode == 'ar'
                      ? '$minutes دقيقة'
                      : '$minutes minute${minutes > 1 ? 's' : ''}';
                }

                // Handle case: less than 1 minute
                if (timeText.trim().isEmpty) {
                  timeText = Get.locale?.languageCode == 'ar'
                      ? 'أقل من دقيقة'
                      : 'less than a minute';
                }

                if (Get.locale?.languageCode == 'ar') {
                  if (upcomingTaskCount.value > 1) {
                    upcomingTaskText.value =
                        'لديك ${upcomingTaskCount.value} مهام مستحقة خلال ${timeText.trim()}!';
                  } else if (upcomingTaskCount.value == 1) {
                    upcomingTaskText.value =
                        'لديك مهمة واحدة مستحقة خلال ${timeText.trim()}!';
                  }
                } else {
                  upcomingTaskText.value =
                      'You have ${upcomingTaskCount.value} task${upcomingTaskCount.value > 1 ? 's' : ''} due in ${timeText.trim()}!';
                }
              }
            }
          },
        );
      } else {
        Messages.getSnackMessage(
          'No internet!'.tr,
          'Loading Tasks from local Database.'.tr,
          ColorsManager.grey,
        );
      }
    } catch (e) {
      Messages.getSnackMessage(
        "Error".tr,
        e.toString().tr,
        ColorsManager.primary,
      );
    }
  }
}
