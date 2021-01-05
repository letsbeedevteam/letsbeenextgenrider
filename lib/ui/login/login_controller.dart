import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/data/souce/remote/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find();
  final GetStorage _sharedPref = Get.find();

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
      _apiService.login(request).then((response) {
        isLoading.value = false;
        if (response.status == 200) {
          _sharedPref
            ..write(Config.RIDER_ID, response.data.id)
            ..write(Config.RIDER_NAME, response.data.name)
            ..write(Config.RIDER_EMAIL, response.data.email)
            ..write(Config.ROLE, response.data.role)
            ..write(
                Config.RIDER_CELLPHONE_NUMBER, response.data.cellphoneNumber)
            ..write(Config.RIDER_ACCESS_TOKEN, response.data.accessToken)
            ..write(Config.IS_LOGGEDIN, true);

          Get.offNamed(Config.DASHBOARD_ROUTE);
        }
      }).catchError((error) {
         // show dialog message
        print(error);
      });
    }
  }
}
