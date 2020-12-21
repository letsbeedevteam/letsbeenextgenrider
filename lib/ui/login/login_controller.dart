import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/models/request/login_request.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/service/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find();
  final GetStorage _sharedPref = Get.find();

  final emailTF = TextEditingController();
  final passwordTF = TextEditingController();

  var isLoading = false.obs;

  void login(String email, String password) {
    isLoading.value = true;

    var request = LoginRequest(email: email, password: password);
    _apiService.login(request).then((response) {
      isLoading.value = false;
      if (response.status == 200) {
        _sharedPref
          ..write(Config.RIDER_ID, response.data.id)
          ..write(Config.RIDER_NAME, response.data.name)
          ..write(Config.RIDER_EMAIL, response.data.email)
          ..write(Config.ROLE, response.data.role)
          ..write(Config.RIDER_CELLPHONE_NUMBER, response.data.cellphoneNumber)
          ..write(Config.RIDER_ACCESS_TOKEN, response.data.accessToken)
          ..write(Config.IS_LOGGEDIN, true);

        Get.offNamed(Config.DASHBOARD_ROUTE);
      }
    }).catchError((error) {
      print(error);
    });

    //   if (emailTF.text.isEmpty || passwordTF.text.isEmpty) {
    //     if (Get.isSnackbarOpen) Get.back();
    //     errorTopSnackbar(
    //         title: 'Required!', message: 'Please input your field(s)');
    //   } else {
    //     isLoading.value = true;

    //     Future.delayed(Duration(seconds: 5)).then((value) {
    //       _apiService
    //           .login(email: emailTF.text.toLowerCase(), password: passwordTF.text)
    //           .then((value) {
    //         isLoading.value = false;

    // if (value.status == 200) {
    //   _box
    //     ..write(Config.USER_REFRESH_TOKEN, value.data.refreshToken)
    //     ..write(Config.USER_TOKEN, value.data.accessToken)
    //     ..write(Config.USER_EMAIL, value.data.email)
    //     ..write(Config.IS_LOGGEDIN, true);
    // } else {
    //           print('Error login: ${value.message}');
    //         }
    //       }).catchError((onError) {
    //         isLoading.value = false;
    //         if (onError.toString().contains('Operation timed out')) {
    //           errorTopSnackbar(title: 'Oops!', message: Config.TIMED_OUT);
    //         } else if (onError.toString().contains('Connection failed')) {
    //           errorTopSnackbar(
    //               title: 'Oops!', message: Config.NO_INTERNET_CONNECTION);
    //         } else {
    //           errorTopSnackbar(title: 'Oops!', message: onError);
    //         }

    //         print('Login Error: $onError');
    //       });
    //     });
    //   }
  }
}
