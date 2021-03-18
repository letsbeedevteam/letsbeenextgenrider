import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/order_address.dart';
import 'package:letsbeenextgenrider/data/models/fee.dart';
import 'package:letsbeenextgenrider/data/models/payment.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';
import 'package:letsbeenextgenrider/data/models/timeframe.dart';

GetHistoryByDateAndStatusResponse getHistoryByDateAndStatusResponseFromJson(
        String str) =>
    GetHistoryByDateAndStatusResponse.fromJson(json.decode(str));

String getHistoryByDateAndStatusResponseToJson(
        GetHistoryByDateAndStatusResponse data) =>
    json.encode(data.toJson());

class GetHistoryByDateAndStatusResponse implements BaseResponse {
  GetHistoryByDateAndStatusResponse({
    this.status,
    this.data,
  });

  @override
  int status;
  List<GetHistoryData> data;

  factory GetHistoryByDateAndStatusResponse.fromJson(
          Map<String, dynamic> json) =>
      GetHistoryByDateAndStatusResponse(
        status: json["status"],
        data: json['data'] == null
            ? null
            : List<GetHistoryData>.from(
                json["data"].map((x) => GetHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetHistoryData {
  GetHistoryData({
    this.orderId,
    this.customerId,
    this.riderId,
    this.riderUserId,
    this.storeId,
    this.customerName,
    this.riderName,
    this.storeName,
    this.orderStatus,
    this.products,
    this.fee,
    this.timeframe,
    this.orderAddress,
    this.payment,
    this.createdAt,
    this.updatedAt,
  });

  int orderId;
  int customerId;
  int riderId;
  int riderUserId;
  int storeId;
  String customerName;
  String riderName;
  String storeName;
  String orderStatus;
  List<Product> products;
  Fee fee;
  Timeframe timeframe;
  OrderAddress orderAddress;
  Payment payment;
  DateTime createdAt;
  DateTime updatedAt;

  factory GetHistoryData.fromJson(Map<String, dynamic> json) => GetHistoryData(
        orderId: json["order_id"],
        customerId: json["customer_id"],
        riderId: json["rider_id"],
        riderUserId: json["rider_user_id"],
        storeId: json["store_id"],
        customerName: json["customer_name"],
        riderName: json["rider_name"],
        storeName: json["store_name"],
        orderStatus: json["order_status"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        fee: Fee.fromJson(json['fee']),
        timeframe: Timeframe.fromJson(json['timeframe']),
        orderAddress: OrderAddress.fromJson(json['order_address']),
        payment: Payment.fromJson(json['payment']),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "customer_id": customerId,
        "rider_id": riderId,
        "rider_user_id": riderUserId,
        "store_id": storeId,
        "customer_name": customerName,
        "rider_name": riderName,
        "store_name": storeName,
        "order_status": orderStatus,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "fee": fee.toJson(),
        "timeframe": timeframe.toJson(),
        "order_address": orderAddress.toJson(),
        "payment": payment.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  bool isEqual(GetHistoryData old) =>
      old.orderId == orderId && old.orderStatus == orderStatus;
}
