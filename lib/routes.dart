import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/service/routes.dart';
import 'package:todo_app_with_notifications/view/achievments/screen/achievments_screen.dart';
import 'package:todo_app_with_notifications/view/authentication/auth/login/screen/login_screen.dart';
import 'package:todo_app_with_notifications/view/authentication/auth/signup/screen/signup_screen.dart';
import 'package:todo_app_with_notifications/view/authentication/landing/screen/landing_screen.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/screen/my_account_screen.dart';
import 'package:todo_app_with_notifications/view/authentication/my_account/screen/task_strikes_screen.dart';
import 'package:todo_app_with_notifications/view/password/screen/change_password_screen.dart';
import 'package:todo_app_with_notifications/view/password/screen/forget_password_screen.dart';

import 'package:todo_app_with_notifications/view/home/screen/home_screen.dart';
import 'package:todo_app_with_notifications/view/notes/screen/add_notes_screen.dart';
import 'package:todo_app_with_notifications/view/notes/screen/notes_screen.dart';
import 'package:todo_app_with_notifications/view/settings/screen/settings_screen.dart';
import 'package:todo_app_with_notifications/view/splash/screen/splash_screen.dart';
import 'package:todo_app_with_notifications/view/tasks/completed_tasks/screen/completed_tasks_screen.dart';
import 'package:todo_app_with_notifications/view/tasks/add_task/screen/add_task_screen.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/screen/incomplete_tasks_screen.dart';
import 'package:todo_app_with_notifications/view/tasks/verify_task_completion/screen/verify_task_completion_screen.dart';
import 'package:todo_app_with_notifications/widgets/about_app_widget.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: Routes.incompleteTasksScreen,
    page: () => IncompleteTasksScreen(),
  ),
  GetPage(
    name: Routes.completedTasksScreen,
    page: () => CompletedTasksScreen(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: Routes.addTaskScreen,
    page: () => AddTaskScreen(),
  ),
  GetPage(
    name: Routes.addNotesScreen,
    page: () => AddNotesScreen(),
  ),
  GetPage(
    name: Routes.notesScreen,
    page: () => NotesScreen(),
  ),
  GetPage(
    name: Routes.myAccountScreen,
    page: () => MyAccountScreen(),
  ),
  GetPage(
    name: Routes.loginScreen,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: Routes.signupScreen,
    page: () => SignupScreen(),
  ),
  GetPage(
    name: Routes.landingScreen,
    page: () => LandingScreen(),
  ),
  GetPage(
    name: Routes.verifyTaskCompletionScreen,
    page: () => VerifyTaskCompletionScreen(),
  ),
  GetPage(
    name: Routes.taskStrikes,
    page: () => TaskStrikesScreen(),
  ),
  GetPage(
    name: Routes.splashScreen,
    page: () => SplashScreen(),
  ),
  GetPage(
    name: Routes.achievementsScreen,
    page: () => AchievmentsScreen(),
  ),
  GetPage(
    name: Routes.settingsSreen,
    page: () => SettingsScreen(),
  ),
  GetPage(
    name: Routes.aboutAppWidget,
    page: () => AboutAppWidget(),
  ),
  GetPage(
    name: Routes.changePasswordScreen,
    page: () => ChangePasswordScreen(),
  ),
  GetPage(
    name: Routes.forgetPasswordScreen,
    page: () => ForgetPasswordScreen(),
  ),
];
