import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_tab_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/delivery_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/history/history_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/profile/profile_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/status/status_view.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _appBar(),
      body: _Body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Lets Bee',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      backgroundColor: const Color(Config.LETSBEE_COLOR).withOpacity(1),
      actions: [
        _logoutbutton(),
      ],
    );
  }

  Widget _logoutbutton() {
    return IconButton(
      icon: const ImageIcon(
        const AssetImage(Config.PNG_PATH + 'logout_button.png'),
        size: 20,
      ),
      onPressed: () {
        showAlertDialog("Are you sure you want to logout?", onConfirm: () {
          controller.logOut();
        });
      },
      splashColor: Colors.black.withOpacity(0.3),
    );
  }
}

class _Body extends BaseTabView<DashboardController> {
  @override
  List<Widget> get tabViews => [
        StatusView(),
        DeliveryView(),
        HistoryView(),
        ProfileView(),
      ];

  @override
  List<Widget> get tabs => [
        buildTab(
            iconPath: 'status_icon.svg',
            iconDescription: 'a suitcase',
            title: 'Status'),
        buildTab(
            iconPath: 'delivery_icon.svg',
            iconDescription: 'a receipt',
            title: 'Delivery'),
        buildTab(
            iconPath: 'history_icon.svg',
            iconDescription: 'an arrow with clock hands',
            title: 'History'),
        buildTab(
            iconPath: 'profile_icon.svg',
            iconDescription: 'a person',
            title: 'Profile'),
      ];
}
