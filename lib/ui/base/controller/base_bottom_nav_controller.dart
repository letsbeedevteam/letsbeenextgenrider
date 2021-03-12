import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseBottomNavController extends GetxController
    with SingleGetTickerProviderMixin {
  TabController tabController;
  int get tabLength;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    tabController = TabController(length: tabLength, vsync: this);
    tabController.addListener(() {
      currentIndex.value = tabController.index;
      if (!tabController.indexIsChanging) {
        onChangeTab(tabController.previousIndex, tabController.index);
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onChangeTab(int prevIndex, int currentIndex) {}
}
