import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/models/additional.dart';
import 'package:letsbeenextgenrider/data/models/choice.dart';
import 'package:letsbeenextgenrider/data/models/menu.dart';
import 'package:letsbeenextgenrider/data/models/pick.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/order_detail_controller.dart';
import 'package:intl/intl.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

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
              IconButton(
                  icon: ImageIcon(
                      AssetImage(Config.PNG_PATH + 'location_button.png'),
                      size: 20),
                  onPressed: () => Get.toNamed(Config.LOCATION_ROUTE,
                      arguments: controller.order.value.toJson()),
                  splashColor: Colors.black.withOpacity(0.3)),
              IconButton(
                  icon: ImageIcon(
                      AssetImage(Config.PNG_PATH + 'chat_button.png'),
                      size: 20),
                  onPressed: () => Get.toNamed(Config.CHAT_ROUTE,
                      arguments: controller.order.value.toJson()),
                  splashColor: Colors.black.withOpacity(0.3))
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
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${controller.order.value.restaurant.name} - ${controller.order.value.restaurant.locationName}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15)),
                              Text('Items',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controller.order.value.menus
                                  .map((e) => _buildMenuItem(e))
                                  .toList()),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                    Text('Contact Number: +23542345345345',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14))
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mode of Payment',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Text('${controller.order.value.payment.method}',
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Row(
                            children: [
                              Text('Status: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14)),
                              GetX<OrderDetailController>(
                                builder: (_) {
                                  return Text('${_.order.value.status}',
                                      style: TextStyle(
                                          color: Colors.green,
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
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 10.0,
                        offset: Offset(3.0, 3.0))
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: GetX<OrderDetailController>(
                                builder: (_) {
                                  return _textStatus();
                                },
                              )),
                          onPressed: () => controller.updateOrderStatus()),
                    ],
                  ))
            ],
          ),
        ));
  }

  Widget _textStatus() {
    var text = 'Mark as PickUp';
    switch (controller.order.value.status) {
      case 'rider-accepted':
        text = 'Mark As PickUp';
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

  Widget _buildMenuItem(Menu menu) {
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
                  child: Text('${menu.quantity}x ${menu.name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
              Text('₱ ${menu.price}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: _buildAdditionalColumn(menu.additionals),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: _buildChoiceColumn(menu.choices),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          menu.note == null
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
                        child: Text('${menu.note}',
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
        additional.picks.isEmpty
            ? Container()
            : Text(additional.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
        Expanded(
            child: Column(
          children: additional.picks.map((e) => _buildAddsOn(e)).toList(),
        ))
      ],
    );
  }

  Widget _buildAddsOn(Pick pick) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: Text(pick.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
        Text('+₱ ${pick.price}',
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
