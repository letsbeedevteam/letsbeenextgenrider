import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_tab_view2.dart';
import 'package:letsbeenextgenrider/ui/dashboard/history/widgets/order_history_item.dart';
import 'package:letsbeenextgenrider/ui/dashboard/status/status_view.dart';
import 'history_controller.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _Body(),
    );
  }
}

class _Body extends BaseTabView2<HistoryController> {
  @override
  List<Widget> get tabViews => [
        Obx(
          () => controller.ordersToday.value.isEmpty
              ? Center(
                  child: Text('No orders to display'),
                )
              : ListView.separated(
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
        Obx(
          () => controller.ordersYesterday.value.isEmpty
              ? Center(
                  child: Text('No orders to display'),
                )
              : ListView.separated(
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
        Obx(
          () => controller.ordersThisWeek.value.isEmpty
              ? Center(
                  child: Text('No orders to display'),
                )
              : ListView.separated(
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
        Obx(
          () => controller.ordersLastWeek.value.isEmpty
              ? Center(
                  child: Text('No orders to display'),
                )
              : ListView.separated(
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
