import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/login_data.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';

class ProfileController extends BaseController {
  static const CLASS_NAME = 'ProfileController';

  final AppRepository appRepository;

  ProfileController({@required this.appRepository});

  LoginData user;
  RxBool isLoading = false.obs;
  RxString totalDeliveriesToday = '0'.obs;
  RxString totalDeliveriesThisMonth = '0'.obs;
  RxString totalDeliveriesAlltime = '0'.obs;
  final DateTime now = DateTime.now();

  @override
  void onRefresh() {
    print('$CLASS_NAME, onRefresh');
    clearDisposables();
    initStats();
  }

  @override
  void onInit() {
    user = appRepository.getUser();
    initStats();
    super.onInit();
  }

  @override
  void onViewVisible() {
    onInit();
    super.onViewVisible();
  }

  @override
  void onViewHide() {
    onClose();
    super.onViewHide();
  }

  void initStats() {
    print('$CLASS_NAME, initStats');
    showSnackbarInfoMessage('Loading data...');
    getTotalDeliveriesToday();
  }

  void getTotalDeliveriesToday() {
    print('$CLASS_NAME, getTotalDeliveriesToday');
    addDisposableFromFuture(
      appRepository
          .getStatsByDate(from: DateTime(now.year, now.month, now.day), to: now)
          .then((response) {
        totalDeliveriesToday.value = '${response.data[0].totalCount}';
        getTotalDeliveriesThisMonth();
      }).catchError(
        (error) {
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getTotalDeliveriesThisMonth() {
    print('$CLASS_NAME, getTotalDeliveriesThisMonth');
    addDisposableFromFuture(
      appRepository
          .getStatsByDate(from: DateTime(now.year, now.month), to: now)
          .then((response) {
        totalDeliveriesThisMonth.value = response.data[0].totalCount.toString();
        getTotalDeliveriesAlltime();
      }).catchError(
        (error) {
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void getTotalDeliveriesAlltime() {
    print('$CLASS_NAME, getTotalDeliveriesAlltime');
    addDisposableFromFuture(
      appRepository
          .getStatsByDate(from: DateTime(2021), to: now)
          .then((response) {
        totalDeliveriesAlltime.value = response.data[0].totalCount.toString();
        showSnackbarSuccessMessage('Data updated!');
      }).catchError(
        (error) {
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void logOut() {
    print('$CLASS_NAME, logOut');
    appRepository.logOut().then((_) {
      Get.offAllNamed(Routes.LOGIN_ROUTE);
    });
  }
}
