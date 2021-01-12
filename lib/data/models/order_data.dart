import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/address.dart';
import 'package:letsbeenextgenrider/data/models/fee.dart';
import 'package:letsbeenextgenrider/data/models/menu.dart';
import 'package:letsbeenextgenrider/data/models/payment.dart';
import 'package:letsbeenextgenrider/data/models/restaurant.dart';
import 'package:letsbeenextgenrider/data/models/timeframe.dart';
import 'package:letsbeenextgenrider/data/models/user.dart';

OrderData orderDataFromJson(String str) =>
    OrderData.fromJson(json.decode(str));

String orderDataToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
  OrderData({
    this.menus,
    this.fee,
    this.timeframe,
    this.address,
    this.payment,
    this.id,
    this.restaurantId,
    this.userId,
    this.riderId,
    this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.restaurant,
  });

  List<Menu> menus;
  Fee fee;
  Timeframe timeframe;
  Address address;
  Payment payment;
  int id;
  int restaurantId;
  int userId;
  dynamic riderId;
  String status;
  dynamic reason;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Restaurant restaurant;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        menus: json["menus"] == null
            ? null
            : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
        fee: Fee.fromJson(json["fee"]),
        timeframe: Timeframe. fromJson(json["timeframe"]),
        address: Address.fromJson(json["address"]),
        payment: Payment.fromJson(json["payment"]),
        id: json["id"],
        restaurantId: json["restaurant_id"],
        userId: json["user_id"],
        riderId: json["rider_id"],
        status: json["status"],
        reason: json["reason"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        "fee": fee.toJson(),
        "timeframe": timeframe.toJson(),
        "address": address.toJson(),
        "payment": payment.toJson(),
        "id": id,
        "restaurant_id": restaurantId,
        "user_id": userId,
        "rider_id": riderId,
        "status": status,
        "reason": reason,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user": user == null ? null : user.toJson(),
        "restaurant": restaurant == null ? null : restaurant.toJson(),
      };
}
