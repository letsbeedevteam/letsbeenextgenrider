import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';

class StatusController extends BaseController {
  static const CLASS_NAME = 'StatusController';

  @override
  void onRefresh() {
    clearDisposables();
    init();
  }

  final AppRepository appRepository;

  StatusController({@required this.appRepository});

  RxBool isSwitchOn = false.obs;
  RxBool isSwitchEnabled = true.obs;
  RxString workStatus = 'You have left work'.obs;
  RxString workStatusIconPath = 'leave_work.svg'.obs;

  DateTime dateToday = DateTime.now();

  void updateWorkStatus(bool isOn) {
    showSnackbarInfoMessage('Updating your status...');
    isSwitchEnabled.value = false;
    appRepository.updateWorkStatus(isOn ? 'off' : 'on').then((isSuccessful) {
      if (isSuccessful) {
        showSnackbarSuccessMessage('Successfully updated your status');
        isSwitchOn.value = !isSwitchOn.value;
        workStatus.value = isSwitchOn.value
            ? 'You are currently at work'
            : 'You have left work';
        workStatusIconPath.value =
            isSwitchOn.value ? 'at_work.svg' : 'leave_work.svg';
      } else {
        showSnackbarErrorMessage('Failed to update your status');
      }
      isSwitchEnabled.value = true;
    }).catchError((error) {
      showSnackbarErrorMessage((error as Failure).errorMessage);
      isSwitchEnabled.value = true;
    });
  }

  void init() {
    //do an api call that will update the current switch work status
    //do an api call that will update the date today
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
}
