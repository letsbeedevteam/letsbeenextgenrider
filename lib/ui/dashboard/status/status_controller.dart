import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/login_data.dart';
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
  LoginData user;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void updateWorkStatus(bool isOn) {
    showSnackbarInfoMessage('Updating status...');
    isSwitchEnabled.value = false;
    appRepository.updateWorkStatus(isOn ? 'off' : 'on').then((isSuccessful) {
      if (isSuccessful) {
        isSwitchOn.value = !isSwitchOn.value;
        workStatus.value = isSwitchOn.value
            ? 'You are currently at work'
            : 'You have left work';
        workStatusIconPath.value =
            isSwitchOn.value ? 'at_work.svg' : 'leave_work.svg';
        showSnackbarSuccessMessage('Work status updated!');
        appRepository.saveRiderStatus(isSwitchOn.value ? 1 : 3);
      } else {
        showSnackbarErrorMessage('Unable to update work status');
      }
      isSwitchEnabled.value = true;
    }).catchError((error) {
      if (error is Failure) {
        showSnackbarErrorMessage(error.errorMessage);
      }
      isSwitchEnabled.value = true;
    });
  }

  void init() {
    user = appRepository.getUser();
    print(user.riderDetails.status.toString());
    isSwitchOn.value = user.riderDetails.status == 3 ? false : true;
    workStatus.value =
        isSwitchOn.value ? 'You are currently at work' : 'You have left work';
    workStatusIconPath.value =
        isSwitchOn.value ? 'at_work.svg' : 'leave_work.svg';
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
