import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/souce/local/sharedpref.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';

class SplashController extends GetxController {
  final SharedPref sharedPref;

  SplashController({@required this.sharedPref});

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (sharedPref.getRiderAccessToken() != null) {
        Get.offAllNamed(Routes.DASHBOARD_ROUTE);
      } else {
        Get.offAllNamed(Routes.LOGIN_ROUTE);
      }
    });
    super.onInit();
  }
}
