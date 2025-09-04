import 'package:get/get.dart';
import 'package:todo_app_with_notifications/core/class/crud.dart';
import 'package:todo_app_with_notifications/view/notifications/controller/notifications_service.dart';

import '../core/service/network_manager.dart';
import '../core/service/user_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud());
    Get.put(UserService(), permanent: true);
    Get.put(NetworkManager(), permanent: true);
    Get.put(NotificationService(), permanent: true).init();
  }
}
