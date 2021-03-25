import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';
import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/variant.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/order_detail_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/widgets/delivery_progressbar_big.dart';
import 'package:letsbeenextgenrider/ui/widget/accept_button.dart';
import 'package:letsbeenextgenrider/ui/widget/animated_expandable_container.dart';
import 'package:letsbeenextgenrider/ui/widget/custom_appbar.dart';
import 'package:letsbeenextgenrider/core/utils/extensions.dart';

import 'widgets/delivery_progressbar_small.dart';

class OrderDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(builder: (_) {
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: CustomAppBar(
            implyLeading: false,
          ),
          body: _Body(),
        ),
        onWillPop: () => _.willPopCallback(),
      );
    });
  }
}

class _Body extends BaseView<OrderDetailController> {
  @override
  Widget get body => Column(
        children: [
          Expanded(
            child: ListView(
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
          _buildDeliveryStatus(),
        ],
      );

  AnimatedExpandableContainer _buildOrderDetails() {
    int numberOfItems = 0;
    controller.order.value.products.forEach((product) {
      numberOfItems += product.quantity;
    });
    return AnimatedExpandableContainer(
      isExpandedAtFirst: false,
      expandingTriggerOnTitleOnly: true,
      vsync: controller,
      expandedIconPath: 'arrow_down_black.svg',
      unexpandedIconPath: 'arrow_up_black.svg',
      title: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white, //needed to take the row size
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Order No. ${controller.order.value.soId}',
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
            child: Row(
              children: [
                SvgPicture.asset(
                  Config.SVG_PATH + 'store_icon.svg',
                  height: 23,
                  width: 23,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                ),
                Text(controller.order.value.store.name),
              ],
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Obx(
            () => controller.order.value.timeframe == null ||
                    controller.order.value.status == 'rider-picked-up' ||
                    controller.order.value.timeframe.storeEstimatedTime == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Config.SVG_PATH + 'preparation_time_icon.svg',
                          height: 23,
                          width: 23,
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                        ),
                        Text(
                            'Preparation time: ${controller.order.value.timeframe.storeEstimatedTime}'),
                      ],
                    ),
                  ),
          ),
          Obx(
            () => controller.order.value.timeframe == null ||
                    controller.order.value.status == 'rider-picked-up' ||
                    controller.order.value.timeframe.storeEstimatedTime == null
                ? const SizedBox.shrink()
                : const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  numberOfItems > 1
                      ? 'Orders ($numberOfItems items)'
                      : 'Orders ($numberOfItems item)',
                ),
                Obx(
                  () => Text(
                    controller.order.value.status == 'rider-picked-up' ||
                            controller.order.value.status == 'delivered'
                        ? 'PHP ${controller.order.value.fee.customerTotalPrice}'
                        : 'PHP ${controller.order.value.fee.sellerTotalPrice}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          Column(
            children: controller.order.value.products
                .map((product) => _buildMenuItem(
                    product, controller.order.value.store.type == 'mart'))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Config.SVG_PATH + 'payment_method_icon.svg',
                  height: 23,
                  width: 23,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                ),
                Text(
                  controller.order.value.payment.method
                      .asReadablePaymentMethod(),
                ),
              ],
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ],
      ),
    );
  }

  AnimatedExpandableContainer _buildCustomerDetails() {
    return AnimatedExpandableContainer(
      isExpandedAtFirst: true,
      expandingTriggerOnTitleOnly: true,
      vsync: controller,
      expandedIconPath: 'arrow_down_black.svg',
      unexpandedIconPath: 'arrow_up_black.svg',
      title: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white, //needed to take the whole row size
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
          controller.order.value.address.note.isBlank
              ? const SizedBox.shrink()
              : const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
          controller.order.value.address.note.isBlank
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    '${controller.order.value.address.note}',
                  ),
                ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ],
      ),
    );
  }

  AnimatedExpandableContainer _buildDeliveryStatus() {
    return AnimatedExpandableContainer(
      isExpandedAtFirst: true,
      expandingTriggerOnTitleOnly: true,
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
              () => controller.hasStartedShopping.value &&
                      controller.order.value.status != 'rider-picked-up'
                  ? Text('You are currently shopping at...')
                  : controller.order.value.status == 'rider-picked-up'
                      ? Row(
                          children: [
                            Text('To receive '),
                            Text(
                              controller.order.value.payment.status == 'paid'
                                  ? 'PHP 0.00 '
                                  : 'PHP ${controller.order.value.fee.customerTotalPrice} ',
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            Text('at'),
                          ],
                        )
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
                title:
                    controller.updateOrderStatusButtonText.value.toUpperCase(),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(Product product, bool isMart) {
    RxBool isChecked = false.obs;
    controller.areItemsreadyForCheckout.addIf(isMart, isChecked);
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isMart
                          ? Obx(
                              () => isMart &&
                                      controller.hasStartedShopping.value
                                  ? Obx(
                                      () => Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        height: 16,
                                        width: 16,
                                        child: Checkbox(
                                          value: isChecked.value,
                                          onChanged: (value) {
                                            isChecked.value = value;
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            )
                          : const SizedBox.shrink(),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${product.name}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Obx(
                                  () => Text(
                                    controller.order.value.status ==
                                                'rider-picked-up' ||
                                            controller.order.value.status ==
                                                'delivered'
                                        ? (product.quantity *
                                                    double.tryParse(product
                                                        .customerPrice) ??
                                                0.0)
                                            .toStringAsFixed(2)
                                        : (product.quantity *
                                                    double.tryParse(
                                                        product.sellerPrice) ??
                                                0.0)
                                            .toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isMart
                                ? const SizedBox.shrink()
                                : product.additionals.isEmpty
                                    ? const SizedBox.shrink()
                                    : _buildAdditionalColumn(
                                        product.additionals),
                            isMart
                                ? const SizedBox.shrink()
                                : product.variants.isEmpty
                                    ? const SizedBox.shrink()
                                    : _buildChoiceColumn(product.variants),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            product.note.isBlank
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
            child: Text(
              additional.name,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Obx(
          () => Text(
            controller.order.value.status == 'rider-picked-up' ||
                    controller.order.value.status == 'delivered'
                ? '${additional.customerPrice}'
                : '${additional.sellerPrice}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceColumn(List<Variant> variants) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          children: variants.map((e) => _buildChoice(e)).toList(),
        )),
      ],
    );
  }

  Widget _buildChoice(Variant variant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text(
              '${variant.type}: ${variant.pick}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Obx(
          () => Text(
            controller.order.value.status == 'rider-picked-up' ||
                    controller.order.value.status == 'delivered'
                ? '${variant.customerPrice}'
                : '${variant.sellerPrice}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
