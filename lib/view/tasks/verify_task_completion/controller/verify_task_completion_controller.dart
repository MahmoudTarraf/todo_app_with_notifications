import 'dart:convert';

import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app_with_notifications/core/const_data/app_animations.dart';
import 'package:todo_app_with_notifications/core/service/app_link.dart';
import 'package:todo_app_with_notifications/data/model/task_model.dart';
import 'package:todo_app_with_notifications/view/tasks/incomplete_tasks/controller/incomplete_tasks_controller.dart';
import 'package:todo_app_with_notifications/view/tasks/verify_task_completion/screen/animation_screen.dart';
import '../../../../core/const_data/app_colors.dart';
import '../../../../core/service/messages.dart';
import '../../../../core/service/network_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';

import '../../../../core/service/routes.dart';

class VerifyTaskCompletionController extends GetxController {
  String? status;
  String? explanation;
  int confidence = 0;
  File? selectedImage;

  Future<void> pickImage() async {
    PermissionStatus status = await Permission.photos.status;

    if (Platform.isAndroid) {
      status = await Permission.storage.status; // for Android <13
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.status; // for iOS or Android 13+
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
    }

    if (!status.isGranted) {
      status = await Permission.photos.request();

      Messages.getSnackMessage(
        'Permission Denied'.tr,
        'You need to allow gallery access to pick an image.'.tr,
        ColorsManager.primary,
      );
      return;
    }

    // 2️⃣ Pick image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return; // User cancelled
    }

    // 3️⃣ Save selected image
    selectedImage = File(pickedFile.path);
    update(); // Notify UI
  }

  Future<void> sendImageWithQuestion(TaskModel task) async {
    try {
      if (await NetworkManager().isOnline()) {
        if (selectedImage == null) {
          Messages.getSnackMessage(
            'No Image!'.tr,
            'Please select an image.'.tr,
            ColorsManager.primary,
          );
          return;
        }

        final question = """
              You are an AI assistant helping to verify if a task was completed based on an image.

              Task Title: ${task.title}
              Task Description: ${task.content}

              Please analyze the image and respond using EXACT labels and format below:

              1. **Completion:** Completed or Not completed.
              2. **Explanation:** A brief explanation.
              3. **Confidence Level:** An integer from 0 to 100.

              Only provide the response with those labels and no extra text.
              """;

        final uri = Uri.parse(AppLink.extractTextFromImage);
        final request = http.MultipartRequest('POST', uri);

        // Attach image
        final mimeType = lookupMimeType(selectedImage!.path) ?? 'image/jpeg';
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
          contentType: MediaType.parse(mimeType),
          filename: basename(selectedImage!.path),
        );
        request.files.add(multipartFile);

        // Attach question
        request.fields['question'] = question;
        Get.to(() => AnimationScreen(
              animationName: AppAnimations.analyzing,
              analysisText: "",
              isLoading: false,
              isCompleted: false,
            ));
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          safeCloseAnimation();
          final data = jsonDecode(response.body);
          parseResponse(data['description']);

          if (status == 'Completed' && confidence >= 80) {
            Get.off(() => AnimationScreen(
                  animationName: AppAnimations.congratulations,
                  analysisText: explanation,
                  isLoading: false,
                  isCompleted: true,
                ));
            final IncompleteTasksController incompleteTasksController =
                Get.put(IncompleteTasksController());

            await incompleteTasksController.markTaskAsCompleted(task);
          } else {
            // If status is 'Not completed' OR confidence < 80
            Get.off(() => AnimationScreen(
                  isLoading: false,
                  animationName: AppAnimations.failure,
                  analysisText: explanation,
                  isCompleted: true,
                ));
          }
        } else {
          safeCloseAnimation();

          Messages.getSnackMessage(
            'Error'.tr,
            '${"Server error:".tr} ${response.statusCode}',
            ColorsManager.primary,
          );
          Get.offNamed(Routes.incompleteTasksScreen);
        }
      } else {
        safeCloseAnimation();

        Messages.getSnackMessage(
          'No Internet'.tr,
          'Please check your connection and try again.'.tr,
          ColorsManager.primary,
        );
        Get.offNamed(Routes.incompleteTasksScreen);
      }
    } catch (e) {
      safeCloseAnimation();
      Messages.getSnackMessage("Error".tr, e.toString(), ColorsManager.primary);
      Get.offNamed(Routes.incompleteTasksScreen);
    }
  }

  void parseResponse(String description) {
    final statusReg = RegExp(r'1\.\s*\*\*Completion:\*\*\s*(.*)');
    final explanationReg =
        RegExp(r'2\.\s*\*\*Explanation:\*\*\s*([\s\S]*?)\n3\.');
    final confidenceReg = RegExp(r'3\.\s*\*\*Confidence Level:\*\*\s*(\d+)');

    final statusMatch = statusReg.firstMatch(description);
    final explanationMatch = explanationReg.firstMatch(description);
    final confidenceMatch = confidenceReg.firstMatch(description);

    status = statusMatch?.group(1)?.trim() ?? 'Unknown';
    explanation = explanationMatch?.group(1)?.trim() ?? '';
    confidence =
        confidenceMatch != null ? int.parse(confidenceMatch.group(1)!) : 0;

    // ✅ Normalize status to standard values
    if (status!.toLowerCase() == 'completed') {
      status = 'Completed';
    } else {
      status = 'Not completed';
    }
  }

  void safeCloseAnimation() {
    if (Get.isOverlaysOpen || Get.currentRoute.contains('AnimationScreen')) {
      Get.back();
    }
  }
}
