import 'dart:async';

import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/pick_up_order_request.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';

class OrderDetailController extends GetxController {
  final DashboardController dashboardController = Get.find();
  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;

  var order = OrderData().obs;
  var updateOrderStatusButtonText = 'Marked as Picked-Up'.obs;

  Timer locationTimer;

  var locations = List<LocationsRequestData>();

  @override
  void onInit() {
    order.value = OrderData.fromJson(_argument);
    sendMyOrderLocation();
    super.onInit();
  }

  @override
  void onClose() {
    locationTimer?.cancel();
    super.onClose();
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
          dashboardController.onInit();
          Get.back();
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
    dashboardController.locationTimer?.cancel();
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

  Future<bool> willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }
}
