class MessageData {
  MessageData(
      {this.id,
      this.userId,
      this.orderId,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.isSent});

  int id;
  int userId;
  int orderId;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSent;

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
      id: json["id"] == null ? null : json["id"],
      userId: json["user_id"] == null ? null : json["user_id"],
      orderId: json["order_id"] == null ? null : json["order_id"],
      message: json["message"] == null ? null : json["message"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      isSent: true);

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "order_id": orderId == null ? null : orderId,
        "message": message == null ? null : message,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
