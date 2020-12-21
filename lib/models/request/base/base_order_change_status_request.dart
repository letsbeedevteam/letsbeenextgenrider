abstract class BaseOrderChangeStatusRequest {
  BaseOrderChangeStatusRequest({
    this.orderId,
  });

  int orderId;

  Map<String, dynamic> toJson() => {
        "oder_id": orderId,
      };
}
