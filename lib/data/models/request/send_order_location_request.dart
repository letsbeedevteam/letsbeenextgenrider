class SendOrderLocationRequest {
  SendOrderLocationRequest({
    this.location,
    this.userId,
  });

  OrderLocationRequestData location;
  int userId;

  Map<String, dynamic> toJson() =>
      {"location": location.toJson(), "user_id": userId};
}

class OrderLocationRequestData {
  OrderLocationRequestData({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
