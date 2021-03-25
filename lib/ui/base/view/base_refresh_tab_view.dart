import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_refresh_tab_controller.dart';

//Use for Dashboard Navigation
//Tabbar is at the top
abstract class BaseRefreshTabView<T extends BaseRefreshTabController>
    extends GetView<T> {
  List<Widget> get tabs;

  ///Needs to have a refresh indicator as parent of a list
  List<Widget> get tabViews;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
        ),
      ],
    );
  }

  Tab buildTab({
    @required String iconPathActive,
    @required String iconPathInActive,
    @required String title,
    @required int index,
  }) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Obx(
          () => Column(
            children: [
              SvgPicture.asset(
                controller.currentIndex.value == index
                    ? Config.SVG_PATH + iconPathActive
                    : Config.SVG_PATH + iconPathInActive,
                height: 25,
                fit: BoxFit.contain,
              ),
              Text(
                title,
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontSize: 10,
                    color: controller.currentIndex.value == index
                        ? Colors.black
                        : Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
