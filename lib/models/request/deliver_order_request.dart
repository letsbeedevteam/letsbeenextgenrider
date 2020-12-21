import 'package:letsbeenextgenrider/models/request/location_request.dart';
import 'package:letsbeenextgenrider/models/request/base/base_order_change_status_request.dart';

class DeliverOrderRequest implements BaseOrderChangeStatusRequest {
  DeliverOrderRequest({
    this.orderId,
    this.location,
  });

  @override
  int orderId;
  List<LocationRequest> location;

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "locations": location,
      };
}
