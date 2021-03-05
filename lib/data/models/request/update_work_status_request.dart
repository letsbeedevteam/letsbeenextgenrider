class UpdateWorkStatusRequest {
  UpdateWorkStatusRequest({
    this.status,
  });

  String status;

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
