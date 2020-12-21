import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/models/order_data.dart';
import 'package:letsbeenextgenrider/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/models/response/get_orders_response.dart';
import 'package:letsbeenextgenrider/models/response/update_order_status_response.dart';
import 'package:letsbeenextgenrider/service/socket_service.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();
  final SocketService socketService = Get.find();
  // final PushNotificationService pushNotificationService = Get.find();
  final GetStorage _sharedPref = Get.find();

  var isLoading = true.obs;
  var message = 'Connecting'.obs;

  var orders = RxList<OrderData>().obs;

  @override
  void onInit() {
    // pushNotificationService.initialize();
    socketService.connectSocket();

    socketService.socket
      ..on('connect', (_) {
        isLoading.value = false;
        message.value = 'Connected';

        fetchAllOrders();
        receiveNewOrders();
      })
      ..on('connecting', (_) {
        isLoading.value = true;
        message.value = 'Connecting';
      })
      ..on('reconnecting', (_) {
        isLoading.value = true;
        message.value = 'Reconnecting';
      })
      ..on('disconnect', (_) {
        if (_sharedPref.read(Config.IS_LOGGEDIN))
          socketService.socket.connect();
        print('Disconnected');
      })
      ..on('error', (_) {
        isLoading.value = false;
        message.value = 'Something went wrong';
        print('Error socket: $_');
      });

    super.onInit();
  }

  void receiveNewOrders() {
    socketService.socket.on('order', (response) async {
      print("NEW ORDER" + response.toString());
      fetchAllOrders();
      // await pushNotificationService.showNotification(
      //     title: 'HEY', body: data.toString());
    });
  }

  void fetchAllOrders() {
    socketService.socket.emitWithAck('orders', '', ack: (response) {
      print(response);
      final _orders = GetOrdersResponse.fromJson(response);

      if (_orders.status == 200) {
        orders.value.clear();
        if (_orders.data.isNotEmpty) {
          orders.value.addAll(_orders.data);
        } else {
          orders.value.clear();
          message.value = "No Orders Available";
        }
      } else {
        message.value = "Failed to fetch orders";
        print("Failed to fetch orders");
      }
    });
  }

  void updateOrderStatus(
      String room, BaseOrderChangeStatusRequest request, OrderData order) {
    socketService.socket.emitWithAck(room, request.toJson(), ack: (response) {
      print(response);
      final updateOrderStatusResponse =
          UpdateOrderStatusResponse.fromJson(response);
      if (updateOrderStatusResponse.status == 200) {
        Get.toNamed(Config.ORDER_DETAIL_ROUTE,
            arguments: updateOrderStatusResponse.data.toJson());
      } else {
        print("Failed to update order status");
      }
    });
  }

  void logOut() {
    socketService.disconnectSocket();
    _sharedPref.write(Config.IS_LOGGEDIN, false);
    Get.offAllNamed(Config.LOGIN_ROUTE);
  }
}
