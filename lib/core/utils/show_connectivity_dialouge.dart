import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'check_firebase_connection.dart';

/// 🔹 Separate function for showing connectivity dialog
void showConnectivityDialog() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.defaultDialog(
      barrierDismissible: false, // User cannot dismiss by tapping outside
      title: Get.locale?.languageCode == 'ar'
          ? 'مشكلة في الاتصال'
          : 'Connectivity Issue',
      middleText: Get.locale?.languageCode == 'ar'
          ? 'قد لا تعمل الإشعارات في منطقتك. يُرجى تفعيل VPN مثل ProtonVPN لتلقي التحديثات.'
          : 'Notifications may not work in your region. Please turn on a VPN like ProtonVPN to receive updates.',
      textConfirm:
          Get.locale?.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry',
      textCancel: Get.locale?.languageCode == 'ar' ? 'خروج' : 'Exit',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.purple,
      onConfirm: () async {
        Get.back(); // close dialog
        final reachable = await checkFirebaseConnection();
        if (!reachable) {
          showConnectivityDialog(); // show dialog again instead of re-running main
        }
      },
      onCancel: () {
        // Exit the app
        SystemNavigator.pop();
      },
    );
  });
}

void showNoticeDialog(BuildContext context) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Title
            Text(
              Get.locale?.languageCode == 'ar' ? '⚠️ تنبيه' : '⚠️ Notice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Message
            Text(
              Get.locale?.languageCode == 'ar'
                  ? 'الرجاء اتباع القواعد:\n'
                      '• أضف مهمة ذات معنى\n'
                      '• المهام بعنوان أو محتوى وهمي لن تفيدك وقد تؤدي إلى إنذار (Task Strike)\n'
                      '• اختر الأولوية بعناية فبناءً عليها قد تكون الإشعارات أكثر\n'
                      '• يمكنك لاحقًا تحديث الموعد النهائي إذا أردت'
                  : 'Please follow the rules:\n'
                      '• Add a meaningful task\n'
                      '• Tasks with fake title or content won’t help and may result in a task strike\n'
                      '• Choose priority wisely, notifications depend on it\n'
                      '• You can later update the deadline if you want',
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // 🔹 OK Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.back(); // dismiss only on button press
              },
              child: Text(
                Get.locale?.languageCode == 'ar' ? 'موافق' : 'OK',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // ❌ disable outside tap dismiss
  );
}
