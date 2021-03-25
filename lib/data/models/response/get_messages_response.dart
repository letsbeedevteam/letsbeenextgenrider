import 'package:letsbeenextgenrider/data/models/message_data.dart';

class GetMessagesResponse {
  GetMessagesResponse({
    this.status,
    this.data,
  });

  String status;
  List<MessageData> data;

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) =>
      GetMessagesResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<MessageData>.from(
                json["data"].map((x) => MessageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
