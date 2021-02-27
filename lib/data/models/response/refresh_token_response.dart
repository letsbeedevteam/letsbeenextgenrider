import 'dart:convert';
import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

RefreshTokenResponse refreshTokenResponseFromJson(String str) =>
    RefreshTokenResponse.fromJson(json.decode(str));

String refreshTokenResponseToJson(RefreshTokenResponse data) =>
    json.encode(data.toJson());

class RefreshTokenResponse implements BaseResponse {
  RefreshTokenResponse({
    this.status,
    this.data,
  });

  @override
  int status;
  RefreshTokenData data;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        status: json["status"],
        data: RefreshTokenData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class RefreshTokenData {
  RefreshTokenData({
    this.accessToken,
  });

  String accessToken;

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      RefreshTokenData(
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}
