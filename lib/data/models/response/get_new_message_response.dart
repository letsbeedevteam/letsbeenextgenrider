import 'package:letsbeenextgenrider/data/models/message_data.dart';

class GetNewMessageResponse {
    GetNewMessageResponse({
        this.status,
        this.data,
    });

    int status;
    MessageData data;

    factory GetNewMessageResponse.fromJson(Map<String, dynamic> json) => GetNewMessageResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : MessageData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data.toJson(),
    };
}