import 'package:flutter/material.dart';

class GetStatsbyDateRequest {
  DateTime to;
  DateTime from;

  GetStatsbyDateRequest({
    @required this.to,
    @required this.from,
  });
}
