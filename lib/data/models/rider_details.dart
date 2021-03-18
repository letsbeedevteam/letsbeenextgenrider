import 'motorcycle_details.dart';

class RiderDetails {
  RiderDetails({
    this.id,
    this.photo,
    this.motorcycleDetails,
    this.status,
  });

  int id;
  String photo;
  MotorcycleDetails motorcycleDetails;
  int status;

  factory RiderDetails.fromJson(Map<String, dynamic> json) => RiderDetails(
        id: json["id"],
        photo: json["photo"],
        motorcycleDetails:
            MotorcycleDetails.fromJson(json["motorcycle_details"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "motorcycle_details": motorcycleDetails.toJson(),
        "status": status,
      };
}
