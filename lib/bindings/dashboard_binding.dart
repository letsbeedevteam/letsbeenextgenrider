import 'package:get/instance_manager.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
