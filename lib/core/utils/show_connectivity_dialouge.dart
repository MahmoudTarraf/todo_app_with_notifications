// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Returns true if user chose "Retry", false if "Continue without VPN"
Future<bool> showConnectivityDialog() async {
  return await Get.dialog<bool>(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            Get.locale?.languageCode == 'ar'
                ? 'مشكلة في الاتصال'
                : 'Connectivity Issue',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            Get.locale?.languageCode == 'ar'
                ? 'قد لا تعمل الإشعارات في منطقتك.\nيمكنك الاستمرار بدون VPN، ولكن قد لا تصلك الإشعارات.'
                : 'Notifications may not work in your region.\nYou can continue without VPN, but notifications may not arrive.',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
            ),
            textAlign: TextAlign.start,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            // Retry Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // purple background
                foregroundColor: Colors.white, // white text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () => Get.back(result: true),
              child: Text(
                Get.locale?.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ),
            // Continue without VPN Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Get.back(result: false),
              child: Text(
                Get.locale?.languageCode == 'ar'
                    ? 'استمرار بدون VPN'
                    : 'Continue without VPN',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ) ??
      false;
}

void showNoticeDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Title
            Text(
              Get.locale?.languageCode == 'ar' ? '⚠️ تنبيه' : '⚠️ Notice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 16.h),

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
              style: TextStyle(fontSize: 16.sp),
            ),
            const SizedBox(height: 20),

            // 🔹 OK Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.r),
                ),
              ),
              onPressed: () {
                Get.back(); // dismiss only on button press
              },
              child: Text(
                Get.locale?.languageCode == 'ar' ? 'موافق' : 'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // ❌ disable outside tap dismiss
  );
}
