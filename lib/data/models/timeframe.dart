class Timeframe {
  Timeframe({
    this.storePickTime,
    this.storeEstimatedTime,
    this.riderPickTime,
    this.riderPickUpTime,
    this.riderEstimatedTime,
    this.deliveredTime,
    this.isNear,
  });

  dynamic storePickTime;
  dynamic storeEstimatedTime;
  dynamic riderPickTime;
  dynamic riderPickUpTime;
  dynamic riderEstimatedTime;
  dynamic deliveredTime;
  bool isNear;

  factory Timeframe.fromJson(Map<String, dynamic> json) => Timeframe(
        storePickTime: json["store_pick_time"],
        storeEstimatedTime: json["store_estimated_time"],
        riderPickTime: json["rider_pick_time"],
        riderPickUpTime: json["rider_pick_up_time"],
        riderEstimatedTime: json["rider_estimated_time"],
        deliveredTime: json["delivered_time"],
        isNear: json["is_near"],
      );

  Map<String, dynamic> toJson() => {
        "store_pick_time": storePickTime,
        "store_estimated_time": storeEstimatedTime,
        "rider_pick_time": riderPickTime,
        "rider_pick_up_time": riderPickUpTime,
        "rider_estimated_time": riderEstimatedTime,
        "delivered_time": deliveredTime,
        "is_near": isNear,
      };
}
