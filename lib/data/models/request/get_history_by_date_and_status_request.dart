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
}
