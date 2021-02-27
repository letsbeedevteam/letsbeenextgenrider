import 'package:flutter/material.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_tab_view2.dart';
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
        StatusView(),
        StatusView(),
        StatusView(),
        StatusView(),
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
