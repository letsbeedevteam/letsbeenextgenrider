import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_tab_controller.dart';

class DashboardController extends BaseTabController {
  static const CLASS_NAME = 'DashboardController';

  final AppRepository appRepository;

  DashboardController({@required this.appRepository});
  
  void logOut() {
    print('$CLASS_NAME, logOut');
    appRepository.logOut().then((_) {
      Get.offAllNamed(Routes.LOGIN_ROUTE);
    });
  }

  @override
  int get tabLength => 4;
}
