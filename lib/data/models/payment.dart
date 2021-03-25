import 'package:letsbeenextgenrider/data/models/details.dart';

class Payment {
  Payment({
    this.method,
    this.status,
    this.details,
  });

  String method;
  String status;
  Details details;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        method: json["method"],
        status: json["status"],
        details: json["details"] == null || json["details"] == ''
            ? null
            : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "status": status,
        "details": details.toJson(),
      };
}
