import 'motorcycle_details.dart';

class RiderDetails {
  RiderDetails({
    this.id,
    this.photo,
    this.motorcycleDetails,
  });

  int id;
  String photo;
  MotorcycleDetails motorcycleDetails;

  factory RiderDetails.fromJson(Map<String, dynamic> json) => RiderDetails(
        id: json["id"],
        photo: json["photo"],
        motorcycleDetails: MotorcycleDetails.fromJson(json["motorcycle_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "motorcycle_details": motorcycleDetails.toJson(),
      };
}
