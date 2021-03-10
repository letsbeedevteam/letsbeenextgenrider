import 'package:flutter/material.dart';

class GetHistoryByDateAndStatusRequest {
  DateTime to;
  DateTime from;
  String status;

  GetHistoryByDateAndStatusRequest({
    @required this.to,
    @required this.from,
    @required this.status,
  });

  Map<String, dynamic> toJson() => {
        "to": to.toIso8601String(),
        "from": from.toIso8601String(),
        "status": status,
      };
}
