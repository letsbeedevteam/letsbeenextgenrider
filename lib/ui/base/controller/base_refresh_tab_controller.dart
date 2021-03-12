import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';

abstract class BaseRefreshTabController extends BaseController
    with SingleGetTickerProviderMixin {
  static const CLASS_NAME = 'BaseRefreshTabController';

  TabController tabBarController;
  int get tabLength;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    tabBarController = TabController(length: tabLength, vsync: this);
    tabBarController.addListener(() {
      message.value = '';
      currentIndex.value = tabBarController.index;
      if (!tabBarController.indexIsChanging) {
        onChangeTab(tabBarController.index);
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    tabBarController.dispose();
    super.onClose();
  }

  void onChangeTab(int index) {}

  void onRefresh();
}
