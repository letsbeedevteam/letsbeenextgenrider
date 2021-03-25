import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_bottom_nav_controller.dart';

//Use for Dashboard Navigation
//Tabbar is at the bottom
abstract class BaseBottomNavView<T extends BaseBottomNavController>
    extends GetView<T> {
  List<Tab> get navBarItems;
  List<Widget> get pages;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: pages,
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: TabBar(
            controller: controller.tabController,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
              color: Color(Config.LETSBEE_COLOR).withOpacity(1),
            ),
            tabs: navBarItems,
          ),
        ),
      ],
    );
  }

  Tab buildBottomNavItem({
    @required String iconPathActive,
    @required String iconPathInActive,
    @required String label,
    @required int index,
  }) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                controller.currentIndex.value == index
                    ? Config.SVG_PATH + iconPathActive
                    : Config.SVG_PATH + iconPathInActive,
                height: 25,
                fit: BoxFit.contain,
              ),
              Text(
                label,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 10,
                  color: controller.currentIndex.value == index
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
