import 'package:flutter/material.dart';

class GetHistoryByDateAndStatusRequest {
  DateTime to;
  DateTime from;
  int page;

  GetHistoryByDateAndStatusRequest({
    @required this.to,
    @required this.from,
    @required this.page,
  });

  Map<String, dynamic> toJson() => {
        "to": to.toIso8601String(),
        "from": from.toIso8601String(),
        "page": page,
      };
}
