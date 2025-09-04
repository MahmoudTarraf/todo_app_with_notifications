import 'package:get/get.dart';

import '../../data/model/user_model.dart';

class UserService extends GetxService {
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  void setUser(UserModel user) {
    userModel.value = user;
  }

  UserModel? get currentUser => userModel.value;
}
