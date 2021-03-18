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

  final DateTime now = DateTime.now();

  @override
  int get tabLength => 4;

  @override
  void onInit() {
    ordersTodayScrollController = ScrollController();
    ordersTodayScrollController.addListener(() {
      if (ordersTodayScrollController.offset >=
              ordersTodayScrollController.position.maxScrollExtent &&
          !ordersTodayScrollController.position.outOfRange) {
        getTodayHistory();
      }
    });

    ordersYesterdayScrollController = ScrollController();
    ordersYesterdayScrollController.addListener(() {
      if (ordersYesterdayScrollController.offset >=
              ordersYesterdayScrollController.position.maxScrollExtent &&
          !ordersYesterdayScrollController.position.outOfRange) {
        getYesterdayHistory();
      }
    });

    ordersThisWeekScrollController = ScrollController();
    ordersThisWeekScrollController.addListener(() {
      if (ordersThisWeekScrollController.offset >=
              ordersThisWeekScrollController.position.maxScrollExtent &&
          !ordersThisWeekScrollController.position.outOfRange) {
        getThisWeekHistory();
      }
    });

    ordersLastWeekScrollController = ScrollController();
    ordersLastWeekScrollController.addListener(() {
      if (ordersLastWeekScrollController.offset >=
              ordersLastWeekScrollController.position.maxScrollExtent &&
          !ordersLastWeekScrollController.position.outOfRange) {
        getLastWeekHistory();
      }
    });
    super.onInit();
  }

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
              page: ordersTodayPageNumber)
          .then((response) {
        if (response.data.isNotEmpty) {
          ordersTodayPageNumber += 1;
        }
        ordersToday.value.addAll(response.data);

        isLoading.value = false;
        message.value = ordersToday.value.isNotEmpty
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
              page: ordersYesterdayPageNumber)
          .then((response) {
        ordersYesterday.value.addAll(response.data);
        isLoading.value = false;
        if (response.data.isNotEmpty) {
          ordersYesterdayPageNumber += 1;
        }
        message.value = ordersYesterday.value.isNotEmpty
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
              page: ordersThisWeekPageNumber)
          .then((response) {
        ordersThisWeek.value.addAll(response.data);
        if (response.data.isNotEmpty) {
          ordersThisWeekPageNumber += 1;
        }
        message.value = ordersThisWeek.value.isNotEmpty
            ? ''
            : 'Nothing to see here yet.\nStart accepting deliveries!';
        isLoading.value = false;
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
              page: ordersLastWeekPageNumber)
          .then((response) {
        ordersLastWeek.value.addAll(response.data);
        if (response.data.isNotEmpty) {
          ordersLastWeekPageNumber += 1;
        }
        isLoading.value = false;
        message.value = ordersLastWeek.value.isNotEmpty
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
