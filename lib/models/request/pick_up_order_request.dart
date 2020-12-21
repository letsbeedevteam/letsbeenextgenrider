import 'package:letsbeenextgenrider/models/request/base/base_order_change_status_request.dart';

class PickUpOrderRequest implements BaseOrderChangeStatusRequest {
  PickUpOrderRequest({
    this.orderId,
  });

  @override
  int orderId;

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
      };
}
