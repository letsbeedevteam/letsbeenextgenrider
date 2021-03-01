import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

GetNearbyOrdersResponse getNearbyOrdersResponseFromJson(String str) =>
    GetNearbyOrdersResponse.fromJson(json.decode(str));

String getNearbyOrdersResponseToJson(GetNearbyOrdersResponse data) =>
    json.encode(data.toJson());

class GetNearbyOrdersResponse implements BaseResponse {
  GetNearbyOrdersResponse({
    this.status,
    this.data,
  });

  @override
  int status;
  List<OrderData> data;

  factory GetNearbyOrdersResponse.fromJson(Map<String, dynamic> json) =>
      GetNearbyOrdersResponse(
        status: json["status"],
        data: List<OrderData>.from(
            json["data"].map((x) => OrderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
