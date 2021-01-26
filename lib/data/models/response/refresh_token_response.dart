// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

RefreshTokenResponse refreshTokenResponseFromJson(String str) =>
    RefreshTokenResponse.fromJson(json.decode(str));

String refreshTokenResponseToJson(RefreshTokenResponse data) =>
    json.encode(data.toJson());

class RefreshTokenResponse implements BaseResponse {
  RefreshTokenResponse({
    this.status,
    this.message,
    this.token,
    this.code,
  });

  @override
  int status;
  String message;
  String token;
  int code;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "code": code,
      };
}
