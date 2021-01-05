import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';

class AcceptOrderRequest implements BaseOrderChangeStatusRequest {
  AcceptOrderRequest({
    this.orderId,
    this.choice,
  });

  @override
  int orderId;
  String choice;

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "choice": choice,
      };
}
