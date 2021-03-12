import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/response/get_history_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_refresh_tab_controller.dart';

class HistoryController extends BaseRefreshTabController
    with SingleGetTickerProviderMixin {
  static const CLASS_NAME = 'HistoryController';

  final AppRepository appRepository;

  HistoryController({@required this.appRepository});

  Rx<RxList<GetHistoryData>> ordersToday = RxList<GetHistoryData>().obs;
  Rx<RxList<GetHistoryData>> ordersYesterday = RxList<GetHistoryData>().obs;
  Rx<RxList<GetHistoryData>> ordersThisWeek = RxList<GetHistoryData>().obs;
  Rx<RxList<GetHistoryData>> ordersLastWeek = RxList<GetHistoryData>().obs;

  final DateTime now = DateTime.now();

  RxString todayMessage = ''.obs;
  RxString yesterdayMessage = ''.obs;
  RxString thisweekMessage = ''.obs;
  RxString lastweekMessage = ''.obs;

  @override
  int get tabLength => 4;

  @override
  void onChangeTab(int index) {
    clearDisposables();
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

  @override
  void onRefresh() {
    isLoading.value = true;
    clearDisposables();
    switch (tabBarController.index) {
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
  }

  @override
  void onViewVisible() {
    clearDisposables();
    switch (tabBarController.index) {
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
    super.onViewVisible();
  }

  void getTodayHistory() {
    showSnackbarInfoMessage('Updating list...');
    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(now.year, now.month, now.day, 0, 0, 0), to: now)
          .then((response) {
        ordersToday.value.clear();
        ordersToday.value.addAll(response.data);
        isLoading.value = false;
        message.value =
            ordersToday.value.isNotEmpty ? '' : 'No Orders to display';
        showSnackbarSuccessMessage('Successfully updated list');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getYesterdayHistory() {
    showSnackbarInfoMessage('Updating list...');
    DateTime yesterday = now;
    yesterday = yesterday.subtract(Duration(days: 1));

    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(
                  yesterday.year, yesterday.month, yesterday.day, 0, 0, 0),
              to: DateTime(
                  yesterday.year, yesterday.month, yesterday.day, 23, 59, 59))
          .then((response) {
        ordersYesterday.value.clear();
        ordersYesterday.value.addAll(response.data);
        isLoading.value = false;
        message.value =
            ordersYesterday.value.isNotEmpty ? '' : 'No Orders to display';
        showSnackbarSuccessMessage('Successfully updated list');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getThisWeekHistory() {
    showSnackbarInfoMessage('Updating list...');
    DateTime thisSunday = now;

    while (thisSunday.weekday != DateTime.sunday) {
      thisSunday = thisSunday.subtract(new Duration(days: 1));
    }

    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(
                  thisSunday.year, thisSunday.month, thisSunday.day, 0, 0, 0),
              to: now)
          .then((response) {
        ordersThisWeek.value.clear();
        ordersThisWeek.value.addAll(response.data);
        message.value =
            ordersThisWeek.value.isNotEmpty ? '' : 'No Orders to display';
        isLoading.value = false;
        showSnackbarSuccessMessage('Successfully updated list');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getLastWeekHistory() {
    showSnackbarInfoMessage('Updating list...');
    DateTime thisSunday = DateTime.now();

    while (thisSunday.weekday != DateTime.sunday) {
      thisSunday = thisSunday.subtract(new Duration(days: 1));
    }

    DateTime prevSunday = thisSunday.subtract(new Duration(days: 7));
    DateTime prevSat = prevSunday.add(new Duration(days: 6));

    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(
                  prevSunday.year, prevSunday.month, prevSunday.day, 0, 0, 0),
              to: DateTime(
                  prevSat.year, prevSat.month, prevSat.day, 23, 59, 59))
          .then((response) {
        ordersLastWeek.value.clear();
        ordersLastWeek.value.addAll(response.data);
        isLoading.value = false;
        message.value =
            ordersLastWeek.value.isNotEmpty ? '' : 'No Orders to display';
        showSnackbarSuccessMessage('Successfully updated list');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }
}
