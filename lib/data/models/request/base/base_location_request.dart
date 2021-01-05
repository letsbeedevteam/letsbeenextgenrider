abstract class BaseLocationRequest {
  BaseLocationRequest({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};
}
