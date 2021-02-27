import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/login_data.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';

class ProfileController extends GetxController {
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
  void onInit() {
    user = appRepository.getUser();
    super.onInit();
    initStats();
  }

  void initStats() {
    getTotalDeliveriesToday();
    getTotalDeliveriesThisMonth();
    getTotalDeliveriesAlltime();
  }

  void getTotalDeliveriesToday() {
    appRepository
        .getStatsByDate(from: DateTime(now.year, now.month, now.day), to: now)
        .then((response) {
      totalDeliveriesToday.value = '${response.data[0].totalCount}';
    }).catchError((error) {
      print((error as Failure).errorMessage);
    });
  }

  void getTotalDeliveriesThisMonth() {
    appRepository
        .getStatsByDate(from: DateTime(now.year, now.month), to: now)
        .then((response) {
      totalDeliveriesThisMonth.value = response.data[0].totalCount.toString();
    }).catchError((error) {
      print((error as Failure).errorMessage);
    });
  }

  void getTotalDeliveriesAlltime() {
    appRepository
        .getStatsByDate(from: DateTime(2021), to: now)
        .then((response) {
      totalDeliveriesAlltime.value = response.data[0].totalCount.toString();
    }).catchError((error) {
      print((error as Failure).errorMessage);
    });
  }

  void logOut() {
    print('$CLASS_NAME, logOut');
    appRepository.logOut().then((_) {
      Get.offAllNamed(Routes.LOGIN_ROUTE);
    });
  }
}
