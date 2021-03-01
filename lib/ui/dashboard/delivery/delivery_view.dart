import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_refresh_view.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_status_view.dart';
import 'package:letsbeenextgenrider/ui/widget/order_item.dart';

import 'delivery_controller.dart';

class DeliveryView extends BaseStatusView<DeliveryController> {
  @override
  Widget get body => _Body();

  @override
  RxString get statusMessage => controller.statusMessage;

  @override
  Rx<MaterialColor> get statusColor => controller.statusColor;
}

class _Body extends BaseRefreshView<DeliveryController> {
  @override
  Widget get body => Obx(
        () => controller.orders.value.isEmpty
            ? ListView(
                children: [
                  const SizedBox.shrink(),
                ],
              )
            : ListView.separated(
                shrinkWrap: false,
                itemBuilder: (context, index) => OrderItem(
                  order: controller.orders.value[index],
                  onTap: () {
                    controller.acceptOrder(controller.orders.value[index]);
                  },
                ),
                separatorBuilder: (context, index) => const Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                ),
                itemCount: controller.orders.value.length,
              ),
      );
}
