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
      ];

  @override
  List<Widget> get tabs => [
        buildTab(
            iconPath: 'status_icon.svg',
            iconDescription: 'a suitcase',
            title: 'Today'),
        buildTab(
            iconPath: 'delivery_icon.svg',
            iconDescription: 'a receipt',
            title: 'Yesterday'),
        buildTab(
            iconPath: 'history_icon.svg',
            iconDescription: 'an arrow with clock hands',
            title: 'All time'),
      ];
}
