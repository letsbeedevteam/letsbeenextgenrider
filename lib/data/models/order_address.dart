import 'package:letsbeenextgenrider/data/models/location.dart';

 class OrderAddress {
    OrderAddress({
        this.location,
        this.completeAddress,
        this.note,
    });

    Location location;
    String completeAddress;
    String note;

    factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        location: Location.fromJson(json["location"]),
        completeAddress: json["complete_address"],
        note: json["note"],
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "complete_address": completeAddress,
        "note": note,
    };
}