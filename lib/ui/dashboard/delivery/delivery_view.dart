import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_view.dart';
import 'package:letsbeenextgenrider/ui/widget/order_item.dart';

import 'delivery_controller.dart';

class DeliveryView extends BaseView<DeliveryController> {
  @override
  Widget get body => Obx(
        () => Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 32,
            bottom: 16,
          ),
          child: ListView.separated(
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
        ),
      );
}
