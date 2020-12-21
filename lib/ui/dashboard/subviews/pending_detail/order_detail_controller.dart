import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/models/location.dart';
import 'package:letsbeenextgenrider/models/order_data.dart';
import 'package:letsbeenextgenrider/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/models/request/location_request.dart';
import 'package:letsbeenextgenrider/models/request/pick_up_order_request.dart';
import 'package:letsbeenextgenrider/models/response/update_order_status_response.dart';
import 'package:letsbeenextgenrider/service/socket_service.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';

class OrderDetailController extends GetxController {
  final SocketService _socketService = Get.find();
  final _argument = Get.arguments;
  final DashboardController _dashboardController = Get.find();

  var order = OrderData().obs;
  var updateOrderStatusButtonText = 'Marked as Picked-Up'.obs;

  @override
  void onInit() {
    order.value = OrderData.fromJson(_argument);
    super.onInit();
  }

  void updateOrderStatus() {
    print('UPDATING STATUS ......');
    print(order.value.status);
    switch (order.value.status) {
      case 'rider-accepted':
        {
          var request = PickUpOrderRequest(orderId: order.value.id);
          _updateOrderStatus('pick-up-order', request);
        }
        break;
      case 'rider-picked-up':
        {
          var locations = List<LocationRequest>()
            ..add(LocationRequest(
                lat: "100", lng: "200", datetime: DateTime.now()));
          var request =
              DeliverOrderRequest(orderId: order.value.id, location: locations);
          _updateOrderStatus('delivered', request);
        }
        break;
      default:
        {
          _dashboardController.fetchAllOrders();
          Get.back();
        }
        break;
    }
  }

  void _updateOrderStatus(String room, BaseOrderChangeStatusRequest request) {
    _dashboardController.socketService.socket
        .emitWithAck(room, request.toJson(), ack: (response) {
      print(response);
      // Clipboard.setData(ClipboardData(text: response.toString()));

      final updateOrderStatusResponse =
          UpdateOrderStatusResponse.fromJson(response);
      if (updateOrderStatusResponse.status == 200) {
        order.value = updateOrderStatusResponse.data;
      } else {
        print("Failed to update order status");
      }

      Clipboard.setData(ClipboardData(text: response.toString()));
    });
  }

  Future<bool> willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }
}
