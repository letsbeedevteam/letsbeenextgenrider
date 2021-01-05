import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

class UpdateOrderStatusResponse implements BaseResponse {
  UpdateOrderStatusResponse({this.status, this.data, this.message});

  @override
  int status;
  OrderData data;
  String message;

  factory UpdateOrderStatusResponse.fromJson(Map<String, dynamic> json) =>
      UpdateOrderStatusResponse(
        status: json["status"],
        data: json["data"] == null ? null : OrderData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? null : data.toJson(),
        "message": message,
      };
}
