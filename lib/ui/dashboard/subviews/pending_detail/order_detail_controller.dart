import 'dart:async';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/pick_up_order_request.dart';

class OrderDetailController extends GetxController {
  static const CLASS_NAME = 'OrderDetailController';

  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;
  Timer _locationTimer;
  List<LocationsRequestData> _locations = List<LocationsRequestData>();

  Rx<OrderData> order = OrderData().obs;
  RxString updateOrderStatusButtonText = 'Marked as Picked-Up'.obs;
  RxBool isLoading = false.obs;

  // GetxController Overrides
  @override
  void onInit() {
    print('$CLASS_NAME, onInit');
    order.value = OrderData.fromJson(_argument);
    _initSocket();
    super.onInit();
  }

  @override
  void onClose() async {
    print('$CLASS_NAME, onClose');
    await _canceLocationTimer();
    super.onClose();
  }

  // Private Functions
  void _initSocket() {
    print('$CLASS_NAME, _initSocket');
    _appRepository.connectSocket(onConnected: (_) {
      _sendMyOrderLocation();
      _receiveNewMessages();
      isLoading.value = false;
    }, onConnecting: (_) {
      isLoading.value = true;
    }, onReconnecting: (_) {
      isLoading.value = true;
    }, onDisconnected: (_) {
      isLoading.value = true;
    }, onError: (_) {
      isLoading.value = false;
    });
  }

  void _receiveNewMessages() {
    print('$CLASS_NAME, _receiveNewMessages');
    _appRepository.receiveNewMessages((response) async {
      await _appRepository.showNotification(
          title: 'Message from ${order.value.user.name}',
          body: "${response.data.message}",
          payload: orderDataToJson(order.value));
    });
  }

  void _updateOrderStatus(String room, BaseOrderChangeStatusRequest request) {
    print('$CLASS_NAME, _updateOrderStatus');
    _appRepository.updateOrderStatus(room, request, (response) {
      isLoading.value = false;
      print(response);
      if (response.status == 200) {
        order.value = response.data;
      } else {
        print("Failed to update order status = $response");
      }
    }, (error) {
      isLoading.value = false;
      print("Failed to update order status == $error");
    });
  }

  Future _canceLocationTimer() {
    print('$CLASS_NAME, _canceLocationTimer');
    return Future.value({_locationTimer?.cancel()});
  }

  void _sendMyOrderLocation() {
    print('$CLASS_NAME, sendMyOrderLocation');
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _appRepository.getCurrentPosition().then((currentLocation) {
        _locations.add(LocationsRequestData(
            lat: currentLocation.latitude,
            lng: currentLocation.longitude,
            datetime: DateTime.now().toUtc()));

        _appRepository.sendMyOrderLocation(order.value.userId, order.value.id);
      });
    });
  }

  // Public Functions
  void updateOrderStatus() {
    print('$CLASS_NAME, updateOrderStatus');
    switch (order.value.status) {
      case 'rider-accepted':
        {
          isLoading.value = true;
          var request = PickUpOrderRequest(orderId: order.value.id);
          _updateOrderStatus('pick-up-order', request);
        }
        break;
      case 'rider-picked-up':
        {
          isLoading.value = true;
          var request = DeliverOrderRequest(
              orderId: order.value.id, locations: _locations);
          _updateOrderStatus('delivered', request);
        }
        break;
      default:
        {
          isLoading.value = false;
          //this should be refactored
          //this will/should never be called
          Get.back();
        }
        break;
    }
  }

  void goBackToDashboard() async {
    print('$CLASS_NAME, goBackToDashboard');
    _appRepository.disconnectSocket().then((isDisconnected) {
      if (isDisconnected) {
        Get.back();
      }
    });
  }

  Future<bool> willPopCallback() async {
    print('$CLASS_NAME, willPopCallback');
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }

  Future<void> makePhoneCall() async {
    String number = '${order.value.user.cellphoneNumber}';
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
