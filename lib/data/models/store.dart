class Store {
  Store({
    // this.location,
    this.name,
    this.longitude,
    this.latitude,
    this.locationName,
    this.type,
  });

  // Location location;
  String name;
  String locationName;
  String longitude;
  String latitude;
  String type;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json["name"],
        locationName: json["location_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "location_name": locationName,
         "type": type,
      };
}
