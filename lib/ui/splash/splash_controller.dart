import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class SplashController extends GetxController {
  final GetStorage _getStorage = Get.find();

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (_getStorage.hasData(Config.IS_LOGGEDIN)) {
        if (_getStorage.read(Config.IS_LOGGEDIN)) {
          Get.offAllNamed(Config.DASHBOARD_ROUTE);
        } else {
          Get.offAllNamed(Config.LOGIN_ROUTE);
        }
      } else {
        Get.offAllNamed(Config.LOGIN_ROUTE);
      }
    });

    super.onInit();
  }
}
