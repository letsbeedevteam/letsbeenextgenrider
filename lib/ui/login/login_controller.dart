import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class LoginController extends GetxController {
  final AppRepository _appRepository = Get.find();

  final emailTF = TextEditingController();
  final passwordTF = TextEditingController();

  var isLoading = false.obs;

  void login() {
    isLoading.value = true;
    // "letsbee-carl@gmail.com","123123123"
    if (emailTF.text.isEmpty) {
      // show dialog message
    } else if (passwordTF.text.isEmpty) {
      // show dialog message
    } else {
      var request = LoginRequest(
          email: emailTF.text.toString(), password: passwordTF.text.toString());

      _appRepository.login(request).then((_) {
        isLoading.value = false;
        Get.offNamed(Config.DASHBOARD_ROUTE);
      }).catchError((error) {
        isLoading.value = false;
        print(error);
      });
    }
  }
}
