class Location {
  Location({
    this.lat,
    this.lng,
    this.name,
  });

  double lat;
  double lng;
  String name;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
      name: json["name"] == null ? null : json["name"]);

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "name": name == null ? null : name,
      };
}
