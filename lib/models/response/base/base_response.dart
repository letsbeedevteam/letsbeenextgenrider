// To parse this JSON data, do
//
//     final baseResponse = baseResponseFromJson(jsonString);

// import 'dart:convert';

// BaseResponse baseResponseFromJson(String str) => BaseResponse.fromJson(json.decode(str));

// String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

abstract class BaseResponse {
    BaseResponse({
        this.status,
    });

    int status;
}
