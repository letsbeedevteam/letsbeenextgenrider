import 'package:letsbeenextgenrider/data/models/request/base/base_location_request.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';

class DeliverOrderRequest implements BaseOrderChangeStatusRequest {
  DeliverOrderRequest({
    this.orderId,
    this.locations,
  });

  @override
  int orderId;
  List<LocationsRequestData> locations;

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "locations": locations,
      };
}

class LocationsRequestData implements BaseLocationRequest {
  LocationsRequestData({
    this.lat,
    this.lng,
    this.datetime,
  });

  @override
  double lat;
  @override
  double lng;

  DateTime datetime;

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "datetime": datetime.toIso8601String(),
      };
}
