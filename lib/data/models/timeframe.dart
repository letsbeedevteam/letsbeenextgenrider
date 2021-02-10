class Timeframe {
    Timeframe({
        this.restaurantPickTime,
        this.restaurantEstimatedTime,
        this.riderPickTime,
        this.riderPickUpTime,
        this.riderEstimatedTime,
        this.deliveredTime,
    });

    String restaurantPickTime;
    String restaurantEstimatedTime;
    dynamic riderPickTime;
    dynamic riderPickUpTime;
    dynamic riderEstimatedTime;
    dynamic deliveredTime;

    factory Timeframe.fromJson(Map<String, dynamic> json) => Timeframe(
        restaurantPickTime: json["store_pick_time"],
        restaurantEstimatedTime: json["store_estimated_time"],
        riderPickTime: json["rider_pick_time"],
        riderPickUpTime: json["rider_pick_up_time"],
        riderEstimatedTime: json["rider_estimated_time"],
        deliveredTime: json["delivered_time"],
    );

    Map<String, dynamic> toJson() => {
        "store_pick_time": restaurantPickTime,
        "store_estimated_time": restaurantEstimatedTime,
        "rider_pick_time": riderPickTime,
        "rider_pick_up_time": riderPickUpTime,
        "rider_estimated_time": riderEstimatedTime,
        "delivered_time": deliveredTime,
    };
}