import 'package:letsbeenextgenrider/models/location.dart';

class Restaurant {
  Restaurant({
    this.location,
    this.name,
  });

  Location location;
  String name;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        location: Location.fromJson(json["location"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "name": name,
      };
}
