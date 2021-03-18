import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_bottom_nav_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';
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

class _Body extends BaseBottomNavView<DashboardController> {
  @override
  List<Widget> get pages => controller.tabViews;

  @override
  List<Tab> get navBarItems => [
        buildBottomNavItem(
          iconPathActive: 'dash_active.svg',
          iconPathInActive: 'dash_inactive.svg',
          label: 'Dashboard',
          index: 0,
        ),
        buildBottomNavItem(
          iconPathActive: 'delivery_active.svg',
          iconPathInActive: 'delivery_inactive.svg',
          label: 'Delivery',
          index: 1,
        ),
        buildBottomNavItem(
          iconPathActive: 'history_active.svg',
          iconPathInActive: 'history_inactive.svg',
          label: 'History',
          index: 2,
        ),
        buildBottomNavItem(
          iconPathActive: 'profile_active.svg',
          iconPathInActive: 'profile_inactive.svg',
          label: 'Profile',
          index: 3,
        ),
      ];
}
