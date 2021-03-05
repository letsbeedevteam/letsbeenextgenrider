class SendCurrentOrderLocationRequest {
  SendCurrentOrderLocationRequest({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}