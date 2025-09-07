import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_translations.dart';
import 'package:todo_app_with_notifications/core/service/my_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_with_notifications/core/service/shared_prefrences_keys.dart';
import 'binding/initial_bindings.dart';
import 'core/const_data/my_theme.dart';
import 'core/service/firebase_options.dart';
import 'core/service/routes.dart';
import 'core/utils/check_firebase_connection.dart';
import 'routes.dart';
import 'view/settings/controller/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initialService();
  Get.put(SettingsController(), permanent: true);

  // 🔹 Check Firebase connectivity
  final bool canReachFirebase = await checkFirebaseConnection();
  if (!canReachFirebase) {
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
            // still not reachable, show again
            main(); // re-run main to show dialog again
          }
        },
        onCancel: () {
          // Exit the app
          SystemNavigator.pop();
        },
      );
    });
  }

  final initialRoute =
      Get.find<MyService>().getBoolData(SharedPrefrencesKeys.isLoginKey) == true
          ? Routes.splashScreen
          : Routes.landingScreen;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initialRoute,
  });
  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return ScreenUtilInit(
      designSize: const Size(411, 891),
      minTextAdapt: true,
      builder: (_, child) {
        return Obx(() => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              translations: AppTranslations(),
              locale: Locale(settingsController.language.value),
              fallbackLocale: const Locale('en'), // fallback to English
              theme: MyTheme.lightTheme,
              darkTheme: MyTheme.darkTheme,
              themeMode: settingsController.theme.value == AppTheme.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              initialBinding: InitialBindings(),
              getPages: routes,
              initialRoute: initialRoute,
            ));
      },
    );
  }
}
