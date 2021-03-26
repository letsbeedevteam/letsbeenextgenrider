import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:letsbeenextgenrider/core/utils/common/snackbar_message_type.dart';

abstract class BaseController extends GetxController {
  static const CLASS_NAME = 'BaseController';

  RxString snackBarMessage = ''.obs;
  RxString message = ''.obs;
  Rx<MaterialColor> snackbarBackgroundColor = Colors.green.obs;
  RxBool isShownSnackbar = false.obs;
  RxBool isLoading = false.obs;
  CancelableOperation hideSnackbar;

  List<CancelableOperation> disposables = List<CancelableOperation>();

  void onRefresh();

  void onViewVisible() {}

  void onViewHide() {}

  @override
  void onClose() {
    clearDisposables();
    super.onClose();
  }

  void clearDisposables() {
    print('$CLASS_NAME, clearDisposables');
    disposables.forEach((disposable) {
      disposable.cancel();
    });
  }

  void addDisposableFromFuture(Future disposable) {
    disposables.add(CancelableOperation.fromFuture(disposable));
  }

  void addDisposable(CancelableOperation disposable) {
    disposables.add(disposable);
  }

  void showSnackbarSuccessMessage(String message) {
    _showSnackbar(
      message,
      SnackBarMessageType.SUCCESS,
      duration: Duration(seconds: 3),
    );
  }

  void showSnackbarErrorMessage(String message) {
    _showSnackbar(
      message,
      SnackBarMessageType.ERROR,
    );
  }

  void showSnackbarInfoMessage(String message) {
    _showSnackbar(
      message,
      SnackBarMessageType.INFO,
    );
  }

  void _showSnackbar(
    String message,
    SnackBarMessageType type, {
    Duration duration,
  }) {
    hideSnackbar?.cancel();
    snackBarMessage.value = message;
    switch (type) {
      case SnackBarMessageType.SUCCESS:
        snackbarBackgroundColor.value = Colors.green;
        break;
      case SnackBarMessageType.ERROR:
        snackbarBackgroundColor.value = Colors.red;
        break;
      case SnackBarMessageType.INFO:
        snackbarBackgroundColor.value = Colors.orange;
        break;
    }

    if (duration != null) {
      hideSnackbar =
          CancelableOperation.fromFuture(Future.delayed(duration).then((_) {
        if (hideSnackbar.isCanceled) return;
        isShownSnackbar.value = false;
        addDisposable(hideSnackbar);
      }));
    }

    isShownSnackbar.value = true;
  }
}
