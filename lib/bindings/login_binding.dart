import 'package:get/instance_manager.dart';
import 'package:letsbeenextgenrider/ui/login/login_controller.dart';

class LoginBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(LoginController());
  }
}