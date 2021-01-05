import 'package:letsbeenextgenrider/data/models/request/base/base_location_request.dart';

class SendLocationRequest {
  SendLocationRequest({
    this.location,
  });

  LocationRequestData location;

  Map<String, dynamic> toJson() => {"location": location.toJson()};
}

class LocationRequestData implements BaseLocationRequest {
  LocationRequestData({
    this.lat,
    this.lng,
  });

  @override
  double lat;
  @override
  double lng;

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
