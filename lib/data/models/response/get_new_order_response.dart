import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

GetNewOrderResponse getNewOrderResponseFromJson(String str) =>
    GetNewOrderResponse.fromJson(json.decode(str));

String getNewOrderResponseToJson(GetNewOrderResponse data) => json.encode(data.toJson());

class GetNewOrderResponse implements BaseResponse {
  GetNewOrderResponse({
    this.status,
    this.data,
  });

  @override
  int status;
  OrderData data;

  factory GetNewOrderResponse.fromJson(Map<String, dynamic> json) =>
      GetNewOrderResponse(
        status: json["status"],
        data: OrderData.fromJson(json["data"]) 
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}
