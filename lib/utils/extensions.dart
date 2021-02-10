import 'package:flutter/material.dart';
import 'package:letsbeenextgenrider/data/models/response/get_active_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_orders_response.dart';

extension receiveOrder on GetNewOrderResponse {
  bool isNewOrder() {
    return this.data.status == 'store-accepted';
  }
}

extension fetchOrdersResponseChecker on dynamic {
  bool isActiveOrderResponse() {
    try {
      GetActiveOrderResponse.fromJson(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isOrdersListResponse() {
    try {
      GetOrdersResponse.fromJson(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

extension readablePaymentMethod on String {
  String asReadablePaymentMethod() {
    String readablePaymentMethod;
    switch (this) {
      case "gcash":
        readablePaymentMethod = "GCash";
        break;
      case "paypal":
        readablePaymentMethod = "PayPal";
        break;
      case "cod":
        readablePaymentMethod = "Cash on Delivery";
        break;
      default:
    }
    return readablePaymentMethod;
  }
}

extension readableOrderStatus on String {
  String asReadableOrderStatus() {
    String readableOrderStatus;
    switch (this) {
      case "pending":
        readableOrderStatus = "Waiting for Restaurant";
        break;
      case "restaurant-accepted":
        readableOrderStatus = "Waiting for Rider";
        break;
      case "restaurant-declined":
        readableOrderStatus = "Restaurant Declined";
        break;
      case "rider-accepted":
        readableOrderStatus = "Rider Accepted";
        break;
      case "rider-picked-up":
        readableOrderStatus = "Rider Picked up";
        break;
      case "delivered":
        readableOrderStatus = "Delivered";
        break;
      case "cancelled":
        readableOrderStatus = "Cancelled";
        break;
      default:
        readableOrderStatus = "Waiting for Restaurant";
        break;
    }
    return readableOrderStatus;
  }
}

extension orderStatusColor on String {
  Color getOrderStatusColor() {
    Color orderStatusColor;
    switch (this) {
      case "pending":
        orderStatusColor = Colors.orange;
        break;
      case "restaurant-accepted":
        orderStatusColor = Colors.green;
        break;
      case "restaurant-declined":
        orderStatusColor = Colors.red;
        break;
      case "rider-accepted":
        orderStatusColor = Colors.green;
        break;
      case "rider-picked-up":
        orderStatusColor = Colors.orange;
        break;
      case "delivered":
        orderStatusColor = Colors.green;
        break;
      case "cancelled":
        orderStatusColor = Colors.red;
        break;
      default:
        orderStatusColor = Colors.orange;
        break;
    }
    return orderStatusColor;
  }
}
