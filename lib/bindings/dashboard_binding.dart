import 'package:get/instance_manager.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/delivery_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/history/history_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/profile/profile_controller.dart';
import 'package:letsbeenextgenrider/ui/dashboard/status/status_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(appRepository: Get.find()));
    Get.lazyPut(() => StatusController());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => DeliveryController(appRepository: Get.find()));
  }
}
