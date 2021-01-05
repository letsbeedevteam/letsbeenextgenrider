import 'package:get/instance_manager.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/subviews/location/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationController());
  }
}
