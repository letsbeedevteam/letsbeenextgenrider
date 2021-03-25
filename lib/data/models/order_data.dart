import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/order_address.dart';
import 'package:letsbeenextgenrider/data/models/fee.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/data/models/payment.dart';
import 'package:letsbeenextgenrider/data/models/store.dart';
import 'package:letsbeenextgenrider/data/models/timeframe.dart';
import 'package:letsbeenextgenrider/data/models/user.dart';

OrderData orderDataFromJson(String str) => OrderData.fromJson(json.decode(str));

String orderDataToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
  OrderData({
    this.products,
    this.fee,
    this.timeframe,
    this.address,
    this.payment,
    this.id,
    this.soId,
    this.storeId,
    this.userId,
    this.riderId,
    this.status,
    this.contractType,
    this.note,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.store,
  });

  List<Product> products;
  Fee fee;
  Timeframe timeframe;
  OrderAddress address;
  Payment payment;
  int id;
  int soId;
  int storeId;
  int userId;
  dynamic riderId;
  String status;
  String contractType;
  String note;
  dynamic reason;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Store store;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        fee: Fee.fromJson(json["fee"]),
        timeframe: json["timeframe"] == null || json["timeframe"] == ""
            ? null
            : Timeframe.fromJson(json["timeframe"]),
        address: OrderAddress.fromJson(json["address"]),
        payment: Payment.fromJson(json["payment"]),
        id: json["id"],
        soId: json["so_id"],
        storeId: json["store_id"],
        userId: json["user_id"],
        riderId: json["rider_id"],
        status: json["status"],
        contractType: json["contract_type"],
        note: json["note"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "fee": fee.toJson(),
        "timeframe": timeframe == null ? null : timeframe.toJson(),
        "address": address.toJson(),
        "payment": payment.toJson(),
        "id": id,
        "so_id": soId,
        "store_id": storeId,
        "user_id": userId,
        "rider_id": riderId,
        "status": status,
        "contract_type": contractType,
        "note": note,
        "reason": reason,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user == null ? null : user.toJson(),
        "store": store == null ? null : store.toJson(),
      };
}
