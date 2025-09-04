//this file for the API

import 'package:todo_app_with_notifications/core/const_data/const_data.dart';

class AppLink {
  // Remote link
  static String appRoot = "https://";
  static String imageWithRoot = "$appRoot/storage";
  static String imageWithoutRoot = "$appRoot/";
  static String serverApiRoot = "$appRoot/api";

  //Local link
  static const String localLink = "https://todo-app-node-backend.onrender.com/";
  static const String aiGeminiLink =
      "https://gemini-node-backend.onrender.com/";
  // ===== AI Gemini Endpoints =====
  static const String extractTextFromImage = "$aiGeminiLink/extract-text";

  // ===== Auth Endpoints =====
  static const String login = "$localLink/auth/login";
  static const String register = "$localLink/auth/register";
  static const String refreshToken =
      "$localLink/auth/refreshToken"; // Assuming you created this route
  static const String getUserDetails =
      "$localLink/auth/getUserDetails"; // GET user profile
  static const String updateUserDetails =
      "$localLink/auth/updateUserDetails"; // PUT user profile
  static const String checkStrikes =
      "$localLink/auth/checkStrikes"; // PUT user profile
  static const String logout = "$localLink/auth/logout"; // logout user
  static const String forgetPassword =
      "$localLink/auth/forgetPassword"; // user forget password, send OTP
  static const String resetPassword =
      "$localLink/auth/resetPassword"; // send otp + new password
  static const String changePassword =
      "$localLink/auth/changePassword"; // logout user
  static const String getHomeData =
      "$localLink/auth/getHomeData"; // logout user

  // ===== Tasks Endpoints =====
  static const String getTasks = "$localLink/tasks/getTasks";
  static const String addTask = "$localLink/tasks/addTask";
  static const String updateTask = "$localLink/tasks/updateTask"; // append /:id
  static const String deleteTask = "$localLink/tasks/deleteTask"; // append /:id
  static const String getFailedTasks = "$localLink/tasks/getFailedTasks";

  // ===== Notes Endpoints =====
  static const String getNotes = "$localLink/notes/getNotes";
  static const String addNote = "$localLink/notes/addNote";
  static const String updateNote = "$localLink/notes/updateNote"; // append /:id
  static const String deleteNote = "$localLink/notes/deleteNote"; // append /:id
  // ===== Achievments Endpoints =====
  static const String users = "$localLink/users";

  Map<String, String> getHeader() {
    Map<String, String> mainHeader = {
      'content-type': 'application/json',
      'Accept': 'application/json',
    };
    return mainHeader;
  }

  Map<String, String> getMultiPartHeader() {
    Map<String, String> mainHeader = {
      "Content-Type": "multipart/form-data",
    };
    return mainHeader;
  }

  Map<String, String> getHeaderToken() {
    Map<String, String> mainHeader = {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ConstData.token}'
    };
    return mainHeader;
  }
}
