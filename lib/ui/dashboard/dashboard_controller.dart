import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_tab_controller.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_view.dart';

import 'delivery/delivery_view.dart';
import 'history/history_view.dart';
import 'profile/profile_view.dart';
import 'status/status_view.dart';

class DashboardController extends BaseTabController {
  static const CLASS_NAME = 'DashboardController';

  final AppRepository appRepository;

  final List<BaseView> tabViews = [
    StatusView(),
    DeliveryView(),
    HistoryView(),
    ProfileView(),
  ];

  DashboardController({@required this.appRepository});

  void logOut() {
    print('$CLASS_NAME, logOut');
    appRepository.logOut().then((_) {
      Get.offAllNamed(Routes.LOGIN_ROUTE);
    });
  }

  @override
  int get tabLength => 4;

  @override
  void onChangeTab(int prevIndex, int currentIndex) {
    tabViews[prevIndex].controller.onViewHide();
    tabViews[currentIndex].controller.onViewVisible();
    // if (prevIndex != 2) {
    //   tabViews[prevIndex].controller.onClose();
    // }
    // if (currentIndex != 2) {
    //   tabViews[currentIndex].controller.onInit();
    // }
    super.onChangeTab(prevIndex, currentIndex);
  }
}
