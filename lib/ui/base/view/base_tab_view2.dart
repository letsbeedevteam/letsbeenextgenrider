import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_tab_controller.dart';

//Use for Dashboard Navigation
//Tabbar is at the top
abstract class BaseTabView2<T extends BaseTabController> extends GetView<T> {
  List<Widget> get tabs;
  List<Widget> get tabViews;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: controller.tabBarController,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
              color: Color(Config.LETSBEE_COLOR).withOpacity(1),
            ),
            tabs: tabs,
          ),
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.tabBarController,
            children: tabViews,
          ),
        ),
      ],
    );
  }

  Tab buildTab({
    @required String iconPath,
    @required String iconDescription,
  }) {
    return Tab(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SvgPicture.asset(
          Config.SVG_PATH + iconPath,
          semanticsLabel: iconDescription,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
