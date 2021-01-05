class FetchAllMessagesRequest {
  FetchAllMessagesRequest({
    this.orderId,
  });

  int orderId;

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
      };
}
