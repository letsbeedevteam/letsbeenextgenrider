import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

GetActiveOrderResponse getActiveOrderResponseFromJson(String str) =>
    GetActiveOrderResponse.fromJson(json.decode(str));

String getActiveOrderResponseToJson(GetActiveOrderResponse data) =>
    json.encode(data.toJson());

class GetActiveOrderResponse implements BaseResponse {
  GetActiveOrderResponse({
    this.status,
    this.data,
  });

  @override
  int status;
  OrderData data;

  factory GetActiveOrderResponse.fromJson(Map<String, dynamic> json) =>
      GetActiveOrderResponse(
        status: json["status"],
        data: json["data"] == null ? null : OrderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? null : data.toJson(),
      };
}
