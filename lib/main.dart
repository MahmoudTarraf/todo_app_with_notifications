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

  final initialRoute =
      Get.find<MyService>().getBoolData(SharedPrefrencesKeys.isLoginKey) == true
          ? Routes.splashScreen
          : Routes.landingScreen;
  runApp(MyApp(
    initialRoute: initialRoute,
  )); // Run the app
}

// !-- this app is todo app with notifications so when you add a task you should add a date and you should post an image of your work which will be analyzed by ChatGPT and confirm your submission //

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
