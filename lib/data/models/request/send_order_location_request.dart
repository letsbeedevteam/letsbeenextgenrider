class SendOrderLocationRequest {
  SendOrderLocationRequest({
    this.location,
    this.userId,
    this.orderId,
  });

  OrderLocationRequestData location;
  int userId;
  int orderId;

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "user_id": userId,
        "order_id": orderId,
      };
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
