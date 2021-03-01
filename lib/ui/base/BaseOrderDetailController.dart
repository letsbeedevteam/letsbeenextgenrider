import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_message_response.dart';

abstract class BaseOrderDetailController extends GetxController {
  AppRepository appRepository = Get.find();

  RxInt unreadMessagesCounter = 0.obs;
  Rx<OrderData> order = OrderData().obs;

  @override
  void onInit() {
    _initSocket();
    super.onInit();
  }

  void _initSocket() {
    // appRepository.connectSocket(
    //     onConnected: (_) {
    //       _receiveNewMessages();
    //     },
    //     onConnecting: (_) {},
    //     onReconnecting: (_) {},
    //     onDisconnected: (_) {},
    //     onError: (_) {});
  }

  void _receiveNewMessages() {
    appRepository.receiveNewMessages((response) {
      unreadMessagesCounter.value += 1;
      onReceiveNewMessage(response);
    });
  }

  // abstract methods
  void onReceiveNewMessage(GetNewMessageResponse response);
}
