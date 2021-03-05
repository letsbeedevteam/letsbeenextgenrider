import 'package:letsbeenextgenrider/data/models/rider_details.dart';

class LoginData {
  LoginData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.cellphoneNumber,
    this.accessToken,
    this.riderDetails,
  });

  int id;
  String name;
  String email;
  String role;
  dynamic cellphoneNumber;
  String accessToken;
  RiderDetails riderDetails;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        cellphoneNumber:
            json["cellphone_number"] == null ? null : json["cellphone_number"],
        accessToken: json["access_token"],
        riderDetails: RiderDetails.fromJson(json["rider"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "cellphone_number": cellphoneNumber == null ? null : cellphoneNumber,
        "access_token": accessToken,
        "rider": riderDetails.toJson(),
      };
}
