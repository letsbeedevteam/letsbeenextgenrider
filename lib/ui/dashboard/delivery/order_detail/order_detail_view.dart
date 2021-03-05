import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';
import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/choice.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/order_detail_controller.dart';
import 'package:letsbeenextgenrider/core/utils/extensions.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/widgets/delivery_progressbar_big.dart';
import 'package:letsbeenextgenrider/ui/widget/accept_button.dart';
import 'package:letsbeenextgenrider/ui/widget/animated_expandable_container.dart';
import 'package:letsbeenextgenrider/ui/widget/custom_appbar.dart';

import 'widgets/delivery_progressbar_small.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CustomAppBar(
          implyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: _buildOrderDetails(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: _buildCustomerDetails(),
                    ),
                  ],
                ),
              ),
            ),
            _buildDeliveryStatus(),
          ],
        ),
      ),
      onWillPop: () => controller.willPopCallback(),
    );
  }

  AnimatedExpandableContainer _buildDeliveryStatus() {
    return AnimatedExpandableContainer(
      isExpandedAtFirst: false,
      vsync: controller,
      expandedIconPath: 'arrow_down_black.svg',
      unexpandedIconPath: 'arrow_up_black.svg',
      isCircularBorder: false,
      arrowColor: Colors.white,
      title: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        color: Colors.grey.shade800,
        child: Row(
          children: [
            Text(
              'DELIVERY IN PROGRESS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      subTitle: DeliveryStatusProgressBarSmall(),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DeliveryStatusProgressBarBig(),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            Obx(
              () => controller.hasStartedShopping.value
                  ? Text('You are currently shopping at...')
                  : Text('You are on your way to...'),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(
                  () => SvgPicture.asset(
                    controller.order.value.status == 'rider-picked-up'
                        ? Config.SVG_PATH + 'destination_icon.svg'
                        : Config.SVG_PATH + 'store_icon.svg',
                    height: 23,
                    width: 23,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Obx(
                        () => controller.order.value.status == 'rider-picked-up'
                            ? Flexible(
                                child: Text(
                                  '${controller.order.value.address.completeAddress}',
                                ),
                              )
                            : controller.order.value.store.locationName.isEmpty
                                ? Flexible(
                                    child: Text(
                                      '${controller.order.value.store.name}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  )
                                : Flexible(
                                    child: Text(
                                      '${controller.order.value.store.name} - ${controller.order.value.store.locationName}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    Config.SVG_PATH + 'location_icon.svg',
                    semanticsLabel: 'N/A',
                    height: 23,
                    width: 23,
                  ),
                  onPressed: () {
                    controller.showMap();
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    Config.SVG_PATH + 'customer_icon.svg',
                    semanticsLabel: 'N/A',
                    height: 23,
                    width: 23,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${controller.order.value.user.name}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        Config.SVG_PATH + 'message_icon.svg',
                        semanticsLabel: 'N/A',
                        height: 23,
                        width: 23,
                      ),
                      onPressed: () {
                        Get.toNamed(
                          Routes.CHAT_ROUTE,
                          arguments: controller.order.value.toJson(),
                        );
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        Config.SVG_PATH + 'call_icon.svg',
                        semanticsLabel: 'N/A',
                        height: 23,
                        width: 23,
                      ),
                      onPressed: () {
                        controller.makePhoneCall();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
            ),
            Obx(
              () => AcceptButton(
                enabled: !controller.isLoading.value,
                onTap: () {
                  showAlertDialog(
                    controller.updateOrderStatusdialogTitle.value,
                    controller.updateOrderStatusdialogMessage.value,
                    onConfirm: () {
                      controller.updateOrderStatus();
                    },
                  );
                },
                title: controller.updateOrderStatusButtonText.value,
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedExpandableContainer _buildCustomerDetails() {
    return AnimatedExpandableContainer(
      isExpandedAtFirst: true,
      vsync: controller,
      expandedIconPath: 'arrow_down_black.svg',
      unexpandedIconPath: 'arrow_up_black.svg',
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Customer Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(controller.order.value.user.name),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${controller.order.value.user.cellphoneNumber}',
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${controller.order.value.address.completeAddress}',
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ],
      ),
    );
  }

  AnimatedExpandableContainer _buildOrderDetails() {
    return AnimatedExpandableContainer(
      isExpandedAtFirst: true,
      vsync: controller,
      expandedIconPath: 'arrow_down_black.svg',
      unexpandedIconPath: 'arrow_up_black.svg',
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Order No. ${controller.order.value.id}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(controller.order.value.store.name),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.order.value.status.asReadableOrderStatus(),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(
                  'PHP ${controller.order.value.fee.total}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mode of Payment',
                ),
                Text(
                  controller.order.value.payment.method
                      .asReadablePaymentMethod(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Column(
            children: controller.order.value.products
                .map((product) => _buildMenuItem(product))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Product product) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.quantity}x',
                        style: TextStyle(color: Colors.black),
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(right: 16),
                      ),
                      Flexible(
                        child: Wrap(
                          children: [
                            Text(
                              '${product.name}',
                              style: TextStyle(color: Colors.black),
                            ),
                            product.additionals.isEmpty
                                ? const SizedBox.shrink()
                                : _buildAdditionalColumn(product.additionals),
                            product.choices.isEmpty
                                ? const SizedBox.shrink()
                                : _buildChoiceColumn(product.choices),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  product.price,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            product.note == null
                ? const SizedBox.shrink()
                : Text(
                    'Note: ${product.note}',
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalColumn(List<Additional> additional) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
              children: additional.map((e) => _buildAdditional(e)).toList()),
        ),
      ],
    );
  }

  Widget _buildAdditional(Additional additional) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text(additional.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        Text('+₱ ${additional.price}',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
      ],
    );
  }

  Widget _buildChoiceColumn(List<Choice> choices) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          children: choices.map((e) => _buildChoice(e)).toList(),
        )),
      ],
    );
  }

  Widget _buildChoice(Choice choice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text('${choice.name}: ${choice.pick}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        Text(
          '+₱ ${choice.price}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
