import 'dart:convert';

import 'package:letsbeenextgenrider/data/models/response/base/base_response.dart';

GetStatsByDateResponse getStatsByDateResponseFromJson(String str) =>
    GetStatsByDateResponse.fromJson(json.decode(str));

String getStatsByDateResponseToJson(GetStatsByDateResponse data) =>
    json.encode(data.toJson());

class GetStatsByDateResponse implements BaseResponse {
  GetStatsByDateResponse({
    this.status,
    this.data,
  });

  @override
  String status;
  List<GetStatsData> data;

  factory GetStatsByDateResponse.fromJson(Map<String, dynamic> json) =>
      GetStatsByDateResponse(
        status: json["status"],
        data: List<GetStatsData>.from(
            json["data"].map((x) => GetStatsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetStatsData {
  GetStatsData({
    this.totalCount,
  });

  String totalCount;

  factory GetStatsData.fromJson(Map<String, dynamic> json) => GetStatsData(
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
      };
}
