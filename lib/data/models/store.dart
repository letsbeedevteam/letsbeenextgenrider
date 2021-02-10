class Store {
  Store({
    // this.location,
    this.name,
    this.longitude,
    this.latitude,
    this.locationName,
  });

  // Location location;
  String name;
  String locationName;
  String longitude;
  String latitude;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        // location: Location.fromJson(json["location"]),
        name: json["name"],
        locationName: json["location_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        // "location": location.toJson(),
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
        "location_name": locationName
      };
}
