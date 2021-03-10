import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_tab_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/delivery_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/history/history_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/profile/profile_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/status/status_view.dart';
import 'package:letsbeenextgenrider/ui/widget/custom_appbar.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(),
      body: _Body(),
    );
  }
}

class _Body extends BaseTabView<DashboardController> {
  @override
  List<Widget> get tabViews => controller.tabViews;

  @override
  List<Widget> get tabs => [
        buildTab(
          iconPath: 'status_icon.svg',
          iconDescription: 'a suitcase',
        ),
        buildTab(
          iconPath: 'delivery_icon.svg',
          iconDescription: 'a receipt',
        ),
        buildTab(
          iconPath: 'history_icon.svg',
          iconDescription: 'an arrow with clock hands',
        ),
        buildTab(
          iconPath: 'profile_icon.svg',
          iconDescription: 'a person',
        ),
      ];
}
