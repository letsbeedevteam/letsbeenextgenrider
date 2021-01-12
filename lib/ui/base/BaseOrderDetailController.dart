import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_message_response.dart';
// import 'package:location/location.dart';

class PushNotificationReceiver {
  void onReceivePushNotification(GetNewMessageResponse message) {}
}

class BaseOrderDetailController extends GetxController {
  AppRepository appRepository = Get.find();

  RxInt unreadMessagesCounter = 0.obs;
  Rx<OrderData> order = OrderData().obs;

  List<LocationsRequestData> locations = List<LocationsRequestData>();
  PushNotificationReceiver receiver;
  // LocationData currentLocation;
  Timer locationTimer;

  @override
  void onInit() {
    _initSocket();
    super.onInit();
  }

  @override
  void onClose() {
    locationTimer?.cancel();
    super.onClose();
  }

  void _initSocket() {
    appRepository.connectSocket(
        onConnected: (_) {
          _receiveNewMessages();
          _sendMyOrderLocation();
        },
        onConnecting: (_) {},
        onReconnecting: (_) {},
        onDisconnected: (_) {},
        onError: (_) {});
  }

  void _receiveNewMessages() {
    appRepository.receiveNewMessages((response) async {
      // await appRepository.showNotification(
      //     title: 'Message from ${order.value.user.name}',
      //     body: "${response.data.message}",
      //     payload: orderDataToJson(order.value));
      receiver?.onReceivePushNotification(response);
    });
  }

  void _sendMyOrderLocation() {
    locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      appRepository.getCurrentPosition().then((currentLocation) {
        locations.add(LocationsRequestData(
            lat: currentLocation.latitude,
            lng: currentLocation.longitude,
            datetime: DateTime.now().toUtc()));

        appRepository.sendMyOrderLocation(order.value.userId);
      });
    });
  }
}
