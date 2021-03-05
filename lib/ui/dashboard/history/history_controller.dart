import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/response/get_history_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_tab_controller.dart';

class HistoryController extends BaseTabController
    with SingleGetTickerProviderMixin {
  static const CLASS_NAME = 'HistoryController';

  final AppRepository appRepository;

  HistoryController({@required this.appRepository});

  Rx<RxList<GetHistoryData>> ordersToday = RxList<GetHistoryData>().obs;
  Rx<RxList<GetHistoryData>> ordersYesterday = RxList<GetHistoryData>().obs;
  Rx<RxList<GetHistoryData>> ordersThisWeek = RxList<GetHistoryData>().obs;
  Rx<RxList<GetHistoryData>> ordersLastWeek = RxList<GetHistoryData>().obs;

  final DateTime now = DateTime.now();

  @override
  int get tabLength => 4;

  @override
  void onInit() {
    getTodayHistory();
    super.onInit();
  }

  @override
  void onChangeTab(int index) {
    switch (index) {
      case 0:
        getTodayHistory();
        break;
      case 1:
        getYesterdayHistory();
        break;
      case 2:
        getThisWeekHistory();
        break;
      case 3:
        getLastWeekHistory();
        break;
    }
    super.onChangeTab(index);
  }

  void getTodayHistory() {
    appRepository
        .getHistoryByDate(
            from: DateTime(now.year, now.month, now.day, 0, 0, 0), to: now)
        .then((response) {
      ordersToday.value.clear();
      ordersToday.value.addAll(response.data);
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
      ordersYesterday.value.clear();
      ordersYesterday.value.addAll(response.data);
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
      ordersThisWeek.value.clear();
      ordersThisWeek.value.addAll(response.data);
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
      ordersLastWeek.value.clear();
      ordersLastWeek.value.addAll(response.data);
    }).catchError((error) {
      print(error);
    });
  }
}
