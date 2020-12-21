import 'package:letsbeenextgenrider/models/request/base/base_order_change_status_request.dart';

class LocationRequest {
  LocationRequest({
    this.lat,
    this.lng,
    this.datetime,
  });

  @override
  String lat;
  String lng;
  DateTime datetime;

  Map<String, dynamic> toJson() =>
      {"lat": lat, "lng": lng, "datetime": datetime.toIso8601String()};
}
