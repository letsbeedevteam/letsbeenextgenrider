import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_refresh_tab_view.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_view.dart';

import 'history_controller.dart';
import 'widgets/order_history_item.dart';

class HistoryView extends BaseView<HistoryController> {
  @override
  Widget get body => Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
          top: 32,
        ),
        child: _Body(),
      );
}

class _Body extends BaseRefreshTabView<HistoryController> {
  @override
  List<Widget> get tabViews => [
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return OrderHistoryItem(
                    vsync: controller,
                    order: controller.ordersToday.value[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8));
                },
                itemCount: controller.ordersToday.value.length),
          ),
        ),
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return OrderHistoryItem(
                    vsync: controller,
                    order: controller.ordersYesterday.value[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8));
                },
                itemCount: controller.ordersYesterday.value.length),
          ),
        ),
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return OrderHistoryItem(
                    vsync: controller,
                    order: controller.ordersThisWeek.value[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8));
                },
                itemCount: controller.ordersThisWeek.value.length),
          ),
        ),
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return OrderHistoryItem(
                    vsync: controller,
                    order: controller.ordersLastWeek.value[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8));
                },
                itemCount: controller.ordersLastWeek.value.length),
          ),
        )
      ];

  @override
  List<Widget> get tabs => [
        buildTab(
          iconPath: 'history_today_icon.svg',
          iconDescription: 'a suitcase',
        ),
        buildTab(
          iconPath: 'history_yesterday_icon.svg',
          iconDescription: 'a receipt',
        ),
        buildTab(
          iconPath: 'history_this_week_icon.svg',
          iconDescription: 'an arrow with clock hands',
        ),
        buildTab(
          iconPath: 'history_last_week_icon.svg',
          iconDescription: 'an arrow with clock hands',
        ),
      ];
}
