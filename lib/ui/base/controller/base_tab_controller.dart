import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseTabController extends GetxController
    with SingleGetTickerProviderMixin {
  TabController tabBarController;
  int get tabLength;

  @override
  void onInit() {
    tabBarController = TabController(length: tabLength, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabBarController.dispose();
    super.onClose();
  }
}
