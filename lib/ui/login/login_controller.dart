import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/utils/utils.dart';

class LoginController extends GetxController {
  final AppRepository _appRepository = Get.find();

  final emailTF = TextEditingController();
  final passwordTF = TextEditingController();
  final emailTFFocusNode = FocusNode();
  final passwordTFFocusNode = FocusNode();

  RxBool isKeyboardActive = false.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    emailTFFocusNode.addListener(() {
      isKeyboardActive.value =
          emailTFFocusNode.hasFocus || passwordTFFocusNode.hasFocus;
    });

    passwordTFFocusNode.addListener(() {
      isKeyboardActive.value =
          emailTFFocusNode.hasFocus || passwordTFFocusNode.hasFocus;
    });
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    emailTF.dispose();
    passwordTF.dispose();
    emailTFFocusNode.dispose();
    passwordTFFocusNode.dispose();

    super.onClose();
  }

  void login() {
    // "letsbee-carl@gmail.com","123123123"
    if (emailTF.text.isEmpty) {
      showSnackbar("Oops!", "You forgot to enter your email address.");
    } else if (passwordTF.text.isEmpty) {
      showSnackbar("Oops!", "You forgot to enter your password.");
    } else {
      isLoading.value = true;
      var request = LoginRequest(
          email: emailTF.text.toString(), password: passwordTF.text.toString());

      _appRepository.login(request).then((_) {
        isLoading.value = false;
        Get.offNamed(Config.DASHBOARD_ROUTE);
      }).catchError((error) {
        print('login error $error');
        isLoading.value = false;
        String title = 'Try Again!';
        String message =
            "We didn't find your email and password in our records. Please double-check them and try again.";
        if (error is SocketException) {
          title = 'Login Failed!';
          message = "You don't have an internet access.";
        }

        showSnackbar(title, message);
      });
    }
  }
}
