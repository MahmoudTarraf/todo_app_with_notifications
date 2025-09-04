import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_with_notifications/core/const_data/app_colors.dart';

class MyTheme {
  static const lightThemeFont = "ComicNeue", darkThemeFont = "Poppins";

  // ✅ Light Theme
  static final lightTheme = ThemeData(
    fontFamily: lightThemeFont,
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: ColorsManager.lightThemeColor,
    scaffoldBackgroundColor: ColorsManager.white,
    colorScheme: ColorScheme.light(
      primary: ColorsManager.lightThemeColor,
      secondary: Colors.deepPurple,
      surface: ColorsManager.white,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: ColorsManager.black,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: ColorsManager.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
        color: ColorsManager.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: ColorsManager.lightThemeColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorsManager.white,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorsManager.black,
        fontSize: 23,
      ),
      iconTheme: IconThemeData(color: ColorsManager.lightThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: ColorsManager.lightThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: ColorsManager.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // ✅ Dark Theme
  static final darkTheme = ThemeData(
    fontFamily: darkThemeFont,
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: ColorsManager.darkThemeColor,
    scaffoldBackgroundColor: ColorsManager.black,
    colorScheme: ColorScheme.dark(
      primary: ColorsManager.darkThemeColor,
      secondary: Colors.deepPurpleAccent,
      surface: const Color(0xFF1E1E1E),
      error: Colors.redAccent,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onError: Colors.black,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
        color: Colors.white70,
      ),
      labelLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: ColorsManager.darkThemeColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: ColorsManager.black,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: ColorsManager.green,
        fontSize: 23,
      ),
      iconTheme: IconThemeData(color: ColorsManager.darkThemeColor),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: ColorsManager.darkThemeColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: ColorsManager.black,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );
}
