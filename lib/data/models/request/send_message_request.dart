class SendMessageRequest {
  SendMessageRequest({
    this.orderId,
    this.customerUserId,
    this.message,
  });

  int orderId;
  int customerUserId;
  String message;

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "customer_user_id": customerUserId,
        "message": message,
      };
}
