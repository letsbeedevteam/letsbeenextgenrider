import 'package:letsbeenextgenrider/data/models/location.dart';

 class OrderAddress {
    OrderAddress({
        this.location,
        this.street,
        this.country,
        this.isoCode,
        this.state,
        this.city,
        this.barangay,
    });

    Location location;
    String street;
    String country;
    String isoCode;
    String state;
    String city;
    String barangay;

    factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        location: Location.fromJson(json["location"]),
        street: json["street"],
        country: json["country"],
        isoCode: json["iso_code"],
        state: json["state"],
        city: json["city"],
        barangay: json["barangay"],
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "street": street,
        "country": country,
        "iso_code": isoCode,
        "state": state,
        "city": city,
        "barangay": barangay,
    };
}