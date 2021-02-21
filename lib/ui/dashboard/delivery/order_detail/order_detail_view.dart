import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';
import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/choice.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/order_detail_controller.dart';
import 'package:letsbeenextgenrider/core/utils/extensions.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => controller.willPopCallback(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
            actions: [
              Obx(() => controller.order.value.status == 'delivered'
                  ? Container()
                  : IconButton(
                      icon: ImageIcon(
                          AssetImage(Config.PNG_PATH + 'location_button.png'),
                          size: 20),
                      onPressed: () => controller.showMap(),
                      splashColor: Colors.black.withOpacity(0.3))),
              Obx(() => controller.order.value.status == 'delivered'
                  ? Container()
                  : Badge(
                      showBadge: false,
                      position: BadgePosition.topEnd(top: 5, end: 5),
                      badgeContent: Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: IconButton(
                          icon: ImageIcon(
                              AssetImage(Config.PNG_PATH + 'chat_button.png'),
                              size: 20),
                          onPressed: () => Get.toNamed(Routes.CHAT_ROUTE,
                              arguments: controller.order.value.toJson()),
                          splashColor: Colors.black.withOpacity(0.3)),
                    ))
            ],
            title: Text('"ORDER NO. ${controller.order.value.id}"',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
            centerTitle: false,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "${controller.order.value.store.name} - ${controller.order.value.store.locationName}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Items',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.order.value.products
                                  .map((e) => _buildMenuItem(e))
                                  .toList()),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Sub Total',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(
                                      '₱ ${controller.order.value.fee.subTotal}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Fee',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(
                                      '₱ ${controller.order.value.fee.delivery}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Promo Code Discount',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(
                                      '₱ ${controller.order.value.fee.discountPrice}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15))
                                ],
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('TOTAL',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Text(
                                        '₱ ${controller.order.value.fee.total}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Divider(
                              thickness: 2, color: Colors.grey.shade200),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivery Details',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Name: ${controller.order.value.user.name}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14)),
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2)),
                                    Text(
                                        'Address: ${controller.order.value.address.street}, ${controller.order.value.address.barangay}, ${controller.order.value.address.city}, ${controller.order.value.address.state}, ${controller.order.value.address.country}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14)),
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2)),
                                    GestureDetector(
                                      onTap: () {
                                        controller.makePhoneCall();
                                      },
                                      child: Text(
                                          'Contact Number: ${controller.order.value.user.cellphoneNumber}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Divider(
                              thickness: 2, color: Colors.grey.shade200),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mode of Payment',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Text(
                                  '${controller.order.value.payment.method.asReadablePaymentMethod()}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Divider(
                              thickness: 2, color: Colors.grey.shade200),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Text('Status: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14)),
                              GetX<OrderDetailController>(
                                builder: (_) {
                                  return Text(
                                      '${_.order.value.status.asReadableOrderStatus()}',
                                      style: TextStyle(
                                          color: _.order.value.status
                                              .getOrderStatusColor(),
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14));
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetX<OrderDetailController>(builder: (_) {
                        return FlatButton(
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(10)),
                            color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: _textStatus()),
                            onPressed: _.isLoading.value
                                ? null
                                : () => {
                                      controller.order.value.status !=
                                              "delivered"
                                          ? _showUpdateOrderStatusDialog()
                                          : controller.goBackToDashboard()
                                    });
                      }),
                    ],
                  ))
            ],
          ),
        ));
  }

  void _showUpdateOrderStatusDialog() {
    var message = 'Do you want to mark this as ';
    switch (controller.order.value.status) {
      case 'rider-accepted':
        message += 'Picked-up';
        break;
      case 'rider-picked-up':
        message += 'Delivered';
        break;
      default:
        message = "";
        break;
    }
    showAlertDialog(message, onConfirm: () {
      controller.updateOrderStatus();
    });
  }

  Widget _textStatus() {
    var text = 'Mark as Picked-up';
    switch (controller.order.value.status) {
      case 'rider-accepted':
        text = 'Mark As Picked-up';
        break;
      case 'rider-picked-up':
        text = 'Mark As Delivered';
        break;
      default:
        text = 'Home';
        break;
    }
    return Text(text,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15));
  }

  Widget _buildMenuItem(Product product) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Text('${product.quantity}x ${product.name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
              Text('₱ ${product.price}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: _buildAdditionalColumn(product.additionals),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: _buildChoiceColumn(product.choices),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          product.note == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Special Request',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 15)),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all()),
                        child: Text('${product.note}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15))),
                  ],
                ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Divider()
        ],
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
        Text('+₱ ${choice.price}',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14))
      ],
    );
  }
}
