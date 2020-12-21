import 'package:get/instance_manager.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(OrderDetailController());
  }
}