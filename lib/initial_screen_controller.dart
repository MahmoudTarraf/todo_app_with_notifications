import 'package:get/get.dart';

import 'core/const_data/app_colors.dart';
import 'core/service/messages.dart';
import 'core/service/my_service.dart';
import 'core/service/shared_prefrences_keys.dart';
import 'core/utils/check_firebase_connection.dart';
import 'core/utils/show_connectivity_dialouge.dart';

class InitialScreenController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final myService = Get.find<MyService>();
    final isNotificationsOn =
        myService.getBoolData(SharedPrefrencesKeys.notifications) ?? true;

    if (!isNotificationsOn) return;

    bool keepTrying = true;

    while (keepTrying) {
      final canReachFirebase = await checkFirebaseConnection();
      if (!canReachFirebase) {
        // Show dialog and wait for user choice
        final retry = await showConnectivityDialog();
        if (!retry) break; // user chose "Continue without VPN"
      } else {
        Get.locale?.languageCode == 'ar'
            ? Messages.getSnackMessage(
                'ملاحظة',
                'الإشعارات تعمل الآن!',
                ColorsManager.cartColor,
              )
            : Messages.getSnackMessage(
                'Note',
                'Notifications Now Working!',
                ColorsManager.cartColor,
              );
        break; // exit loop if reachable
      }
    }
  }
}
