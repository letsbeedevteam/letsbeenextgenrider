import 'package:get/instance_manager.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/subviews/chat/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}
