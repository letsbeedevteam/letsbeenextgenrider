import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  int ordersTodayPageNumber = 0;
  int ordersYesterdayPageNumber = 0;
  int ordersThisWeekPageNumber = 0;
  int ordersLastWeekPageNumber = 0;

  ScrollController ordersTodayScrollController;
  ScrollController ordersYesterdayScrollController;
  ScrollController ordersThisWeekScrollController;
  ScrollController ordersLastWeekScrollController;

  RxString todayHistoryMessage = ''.obs;
  RxString yesterdayHistoryMessage = ''.obs;
  RxString thisweekHistoryMessage = ''.obs;
  RxString lastweekHistoryMessage = ''.obs;

  final DateTime now = DateTime.now();

  @override
  int get tabLength => 4;

  @override
  void onClose() {
    ordersTodayScrollController.dispose();
    ordersYesterdayScrollController.dispose();
    ordersThisWeekScrollController.dispose();
    ordersLastWeekScrollController.dispose();
    super.onClose();
  }

  @override
  void onChangeTab(int index) {
    clearDisposables();
    ordersTodayPageNumber = 0;
    ordersToday.value.clear();
    ordersYesterdayPageNumber = 0;
    ordersYesterday.value.clear();
    ordersThisWeekPageNumber = 0;
    ordersThisWeek.value.clear();
    ordersLastWeekPageNumber = 0;
    ordersLastWeek.value.clear();
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
    ordersTodayPageNumber = 0;
    ordersToday.value.clear();
    ordersYesterdayPageNumber = 0;
    ordersYesterday.value.clear();
    ordersThisWeekPageNumber = 0;
    ordersThisWeek.value.clear();
    ordersLastWeekPageNumber = 0;
    ordersLastWeek.value.clear();
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
    ordersTodayPageNumber = 0;
    ordersToday.value.clear();
    ordersYesterdayPageNumber = 0;
    ordersYesterday.value.clear();
    ordersThisWeekPageNumber = 0;
    ordersThisWeek.value.clear();
    ordersLastWeekPageNumber = 0;
    ordersLastWeek.value.clear();
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
    showSnackbarInfoMessage('Loading History...');
    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(now.year, now.month, now.day, 0, 0, 0),
              to: now,
              page: (ordersToday.value.length * 0.1).toInt())
          .then((response) {
        if ((ordersToday.value.length * 0.1).toInt() == 0) {
          ordersToday.value.clear();
        }

        //Check if last orderid in the list is equal to the order id from the response
        //before adding to list.
        //Check last index only for lightweight computation.
        //Can be refactored and improved.
        if (ordersToday.value.isNotEmpty) {
          if (ordersToday.value.last.orderId != response.data.last.orderId) {
            ordersToday.value.addAll(response.data);
          }
        } else {
          ordersToday.value.addAll(response.data);
        }

        isLoading.value = false;
        todayHistoryMessage.value = ordersToday.value.isNotEmpty
            ? ''
            : 'Nothing to see here yet.\nStart accepting deliveries!';
        showSnackbarSuccessMessage('History updated!');
      }).catchError(
        (error) {
          isLoading.value = false;
          if (error is Failure) {
            showSnackbarErrorMessage(error.errorMessage);
          }
        },
      ),
    );
  }

  void getYesterdayHistory() {
    showSnackbarInfoMessage('Loading History...');
    DateTime yesterday = now;
    yesterday = yesterday.subtract(Duration(days: 1));

    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(
                  yesterday.year, yesterday.month, yesterday.day, 0, 0, 0),
              to: DateTime(
                  yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
              page: (ordersYesterday.value.length * 0.1).toInt())
          .then((response) {
        if ((ordersYesterday.value.length * 0.1).toInt() == 0) {
          ordersYesterday.value.clear();
        }

        //Check if last orderid in the list is equal to the order id from the response
        //before adding to list.
        //Check last index only for lightweight computation.
        //Can be refactored and improved.
        if (ordersYesterday.value.isNotEmpty) {
          if (ordersYesterday.value.last.orderId !=
              response.data.last.orderId) {
            ordersYesterday.value.addAll(response.data);
          }
        } else {
          ordersYesterday.value.addAll(response.data);
        }
        isLoading.value = false;
        yesterdayHistoryMessage.value = ordersYesterday.value.isNotEmpty
            ? ''
            : 'Nothing to see here yet.\nStart accepting deliveries!';
        showSnackbarSuccessMessage('History updated!');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getThisWeekHistory() {
    showSnackbarInfoMessage('Loading History...');
    DateTime thisSunday = now;

    while (thisSunday.weekday != DateTime.sunday) {
      thisSunday = thisSunday.subtract(new Duration(days: 1));
    }

    addDisposableFromFuture(
      appRepository
          .getHistoryByDate(
              from: DateTime(
                  thisSunday.year, thisSunday.month, thisSunday.day, 0, 0, 0),
              to: now,
              page: (ordersThisWeek.value.length * 0.1).toInt())
          .then((response) {
        if ((ordersThisWeek.value.length * 0.1).toInt() == 0) {
          ordersThisWeek.value.clear();
        }

        //Check if last orderid in the list is equal to the order id from the response
        //before adding to list.
        //Check last index only for lightweight computation.
        //Can be refactored and improved.
        if (ordersThisWeek.value.isNotEmpty) {
          if (ordersThisWeek.value.last.orderId != response.data.last.orderId) {
            ordersThisWeek.value.addAll(response.data);
          }
        } else {
          ordersThisWeek.value.addAll(response.data);
        }
        isLoading.value = false;
        thisweekHistoryMessage.value = ordersThisWeek.value.isNotEmpty
            ? ''
            : 'Nothing to see here yet.\nStart accepting deliveries!';

        showSnackbarSuccessMessage('History updated!');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getLastWeekHistory() {
    showSnackbarInfoMessage('Loading History...');
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
                  prevSat.year, prevSat.month, prevSat.day, 23, 59, 59),
              page: (ordersLastWeek.value.length * 0.1).toInt())
          .then((response) {
        if ((ordersLastWeek.value.length * 0.1).toInt() == 0) {
          ordersLastWeek.value.clear();
        }

        //Check if last orderid in the list is equal to the order id from the response
        //before adding to list.
        //Check last index only for lightweight computation.
        //Can be refactored and improved.
        if (ordersLastWeek.value.isNotEmpty) {
          if (ordersLastWeek.value.last.orderId != response.data.last.orderId) {
            ordersLastWeek.value.addAll(response.data);
          }
        } else {
          ordersLastWeek.value.addAll(response.data);
        }
        isLoading.value = false;
        lastweekHistoryMessage.value = ordersLastWeek.value.isNotEmpty
            ? ''
            : 'Nothing to see here yet.\nStart accepting deliveries!';
        showSnackbarSuccessMessage('History updated!');
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }
}
