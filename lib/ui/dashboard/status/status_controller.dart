import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';

class StatusController extends GetxController {
  static const CLASS_NAME = 'StatusController';

  final AppRepository appRepository;

  StatusController({@required this.appRepository});

  RxBool isSwitchOn = false.obs;
  RxString workStatus = 'You have left work'.obs;
  RxString workStatusIconPath = 'door_exit_icon.svg'.obs;

  DateTime dateToday = DateTime.now();

  void updateWorkStatus(bool isOn) {
    appRepository.updateWorkStatus(isOn ? 'off' : 'on').then((isSuccessful) {
      isSwitchOn.value = !isSwitchOn.value;
      workStatus.value =
          isSwitchOn.value ? 'You are currently at work' : 'You have left work';
      workStatusIconPath.value =
          isSwitchOn.value ? 'status_icon.svg' : 'door_exit_icon.svg';
    }).catchError((error) {
      Get.snackbar('Oops!', (error as Failure).errorMessage);
    });
  }
}
