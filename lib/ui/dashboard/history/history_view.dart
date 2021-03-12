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
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  controller.getTodayHistory();
                }
                return false;
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
        ),
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  controller.getYesterdayHistory();
                }
                return false;
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
        ),
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  controller.getThisWeekHistory();
                }
                return false;
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
        ),
        Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              controller.onRefresh();
            },
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent) {
                  controller.getLastWeekHistory();
                }
                return false;
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
          ),
        ),
      ];

  @override
  List<Widget> get tabs => [
        buildTab(
          iconPathActive: 'today_active.svg',
          iconPathInActive: 'today_inactive.svg',
          title: 'Today',
          index: 0,
        ),
        buildTab(
          iconPathActive: 'yesterday_active.svg',
          iconPathInActive: 'yesterday_inactive.svg',
          title: 'Yesterday',
          index: 1,
        ),
        buildTab(
          iconPathActive: 'this_week_active.svg',
          iconPathInActive: 'this_week_inactive.svg',
          title: 'This Week',
          index: 2,
        ),
        buildTab(
          iconPathActive: 'last_week_active.svg',
          iconPathInActive: 'last_week_inactive.svg',
          title: 'Last Week',
          index: 3,
        ),
      ];
}
