import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/response/get_status_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_tab_controller.dart';

class HistoryController extends BaseTabController {
  static const CLASS_NAME = 'HistoryController';

  final AppRepository appRepository;

  HistoryController({@required this.appRepository});

  Rx<RxList<GetHistoryData>> today = RxList<GetHistoryData>().obs;
  final DateTime now = DateTime.now();

  @override
  int get tabLength => 4;

  @override
  void onInit() {
    getTodayHistory();
    getYesterdayHistory();
    getThisWeekHistory();
    getLastWeekHistory();
    super.onInit();
  }

  void getTodayHistory() {
    appRepository
        .getHistoryByDate(
            from: DateTime(now.year, now.month, now.day, 0, 0, 0), to: now)
        .then((response) {
      print('today = ${response.toJson()}');
    }).catchError((error) {
      print(error);
    });
  }

  void getYesterdayHistory() {
    DateTime yesterday = now;
    yesterday = yesterday.subtract(Duration(days: 1));

    appRepository
        .getHistoryByDate(
            from: DateTime(
                yesterday.year, yesterday.month, yesterday.day, 0, 0, 0),
            to: DateTime(
                yesterday.year, yesterday.month, yesterday.day, 23, 59, 59))
        .then((response) {
      print('yesterday = ${response.toJson()}');
    }).catchError((error) {
      print(error);
    });
  }

  void getThisWeekHistory() {
    DateTime thisSunday = now;

    while (thisSunday.weekday != DateTime.sunday) {
      thisSunday = thisSunday.subtract(new Duration(days: 1));
    }

    appRepository
        .getHistoryByDate(
            from: DateTime(
                thisSunday.year, thisSunday.month, thisSunday.day, 0, 0, 0),
            to: now)
        .then((response) {
      print('this week = ${response.toJson()}');
    }).catchError((error) {
      print(error);
    });
  }

  void getLastWeekHistory() {
    DateTime thisSunday = DateTime.now();

    while (thisSunday.weekday != DateTime.sunday) {
      thisSunday = thisSunday.subtract(new Duration(days: 1));
    }

    DateTime prevSunday = thisSunday.subtract(new Duration(days: 7));
    DateTime prevSat = prevSunday.add(new Duration(days: 6));

    appRepository
        .getHistoryByDate(
            from: DateTime(
                prevSunday.year, prevSunday.month, prevSunday.day, 0, 0, 0),
            to: DateTime(prevSat.year, prevSat.month, prevSat.day, 23, 59, 59))
        .then((response) {
      print('last week = ${response.toJson()}');
    }).catchError((error) {
      print(error);
    });
  }
}
