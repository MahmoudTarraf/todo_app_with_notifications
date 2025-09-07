import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';
import 'package:todo_app_with_notifications/core/const_data/app_translations.dart';
import 'package:todo_app_with_notifications/core/service/messages.dart';
import 'package:todo_app_with_notifications/core/service/my_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_with_notifications/core/service/shared_prefrences_keys.dart';
import 'binding/initial_bindings.dart';
import 'core/const_data/my_theme.dart';
import 'core/service/firebase_options.dart';
import 'core/service/routes.dart';
import 'core/utils/check_firebase_connection.dart';
import 'core/utils/show_connectivity_dialouge.dart';
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
  final myService = Get.find<MyService>();

  // 🔹 Check if notifications setting exists
  bool? isNotificationsOn = myService.getBoolData(
    SharedPrefrencesKeys.notifications,
  );

  // 🔹 If null, set it to true for the first time
  if (isNotificationsOn == null) {
    await myService.storeBoolData(SharedPrefrencesKeys.notifications, true);
    isNotificationsOn = true;
  }

  if (isNotificationsOn == true) {
    // 🔹 Check Firebase connectivity
    final bool canReachFirebase = await checkFirebaseConnection();
    if (!canReachFirebase) {
      showConnectivityDialog();
    } else {
      // 🔹 Corrected snack messages
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
    }
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
