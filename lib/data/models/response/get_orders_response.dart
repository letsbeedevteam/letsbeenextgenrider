import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

GetOrdersResponse getOrdersResponseFromJson(String str) =>
    GetOrdersResponse.fromJson(json.decode(str));

String getOrdersResponseToJson(GetOrdersResponse data) =>
    json.encode(data.toJson());

class GetOrdersResponse implements BaseResponse {
  GetOrdersResponse({
    this.status,
    this.data,
  });

  @override
  int status;
  List<OrderData> data;

  factory GetOrdersResponse.fromJson(Map<String, dynamic> json) =>
      GetOrdersResponse(
        status: json["status"],
        data: List<OrderData>.from(json["data"].map((x) => OrderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
