import 'dart:async';

import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/pick_up_order_request.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class OrderDetailController extends GetxController {
  final DashboardController dashboardController = Get.find();
  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;

  Rx<OrderData> order = OrderData().obs;
  RxString updateOrderStatusButtonText = 'Marked as Picked-Up'.obs;

  Timer locationTimer;

  List<LocationsRequestData> locations = List<LocationsRequestData>();

  @override
  void onInit() {
    order.value = OrderData.fromJson(_argument);
    _initSocket();
    super.onInit();
  }

  @override
  void onClose() {
    locationTimer?.cancel();
    super.onClose();
  }

  void _initSocket() {
    _appRepository.connectSocket(
        onConnected: (_) {
          sendMyOrderLocation();
          _receiveNewMessages();
        },
        onConnecting: (_) {},
        onReconnecting: (_) {},
        onDisconnected: (_) {},
        onError: (_) {});
  }

  void updateOrderStatus() {
    switch (order.value.status) {
      case 'rider-accepted':
        {
          var request = PickUpOrderRequest(orderId: order.value.id);
          _updateOrderStatus('pick-up-order', request);
        }
        break;
      case 'rider-picked-up':
        {
          var request = DeliverOrderRequest(
              orderId: order.value.id, locations: locations);
          _updateOrderStatus('delivered', request);
        }
        break;
      default:
        {
          //this should be refactored
          //this will/should never be called
          goToDashboard();
        }
        break;
    }
  }

  void _updateOrderStatus(String room, BaseOrderChangeStatusRequest request) {
    _appRepository.updateOrderStatus(room, request, (response) {
      print(response);
      if (response.status == 200) {
        order.value = response.data;
      } else {
        print("Failed to update order status");
      }
    }, (error) {
      print("Failed to update order status $error");
    });
  }

  void sendMyOrderLocation() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      locationTimer = timer;
      _appRepository.getCurrentPosition().then((currentLocation) {
        locations.add(LocationsRequestData(
            lat: currentLocation.latitude,
            lng: currentLocation.longitude,
            datetime: DateTime.now().toUtc()));

        _appRepository.sendMyOrderLocation(order.value.userId);
      });
    });
  }

  void goToDashboard() {
    dashboardController.initSocket();
    Get.back();
  }

  void goToChatPage() {
    Get.toNamed(Config.CHAT_ROUTE, arguments: order.value.toJson());
  }

  void _receiveNewMessages() {
    _appRepository.receiveNewMessages((response) async {
      await _appRepository.showNotification(
          title: 'Message from ${order.value.user.name}',
          body: "${response.data.message}",
          payload: orderDataToJson(order.value));
    });
  }

  Future<bool> willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }
}
