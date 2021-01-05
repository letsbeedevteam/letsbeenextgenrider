import 'dart:async';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_active_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_orders_response.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();
  AppRepository _appRepository = Get.find();
  // final PushNotificationService pushNotificationService = Get.find();

  var isLoading = true.obs;
  var message = 'No Orders Available'.obs;
  var orders = RxList<OrderData>().obs;

  Timer locationTimer;

  // View Functions
  @override
  void onInit() {
    _initSocket();
    super.onInit();
  }

  @override
  void onClose() {
    _disconnectSocket();
    locationTimer?.cancel();
    super.onClose();
  }

  // Private Functions
  void _initSocket() {
    // pushNotificationService.initialize();
    _appRepository.connectSocket(
        onConnected: (_) {
          isLoading.value = false;
          message.value = 'Connected';

          fetchAllOrders();
        },
        onConnecting: (_) {
          isLoading.value = true;
          message.value = 'Connecting';
        },
        onReconnecting: (_) {
          isLoading.value = true;
          message.value = 'Reconnecting';
        },
        onDisconnected: (_) {},
        onError: (_) {
          isLoading.value = false;
          message.value = 'Something went wrong';
        });
  }

  void _receiveNewOrders() {
    _appRepository.receiveNewOrder(() => {fetchAllOrders()});
  }

  void _disconnectSocket() {
    _appRepository.disconnectSocket();
  }

  // Public Functions
  void fetchAllOrders() {
    _appRepository.fetchAllOrders((response) {
      print(response.toString());
      // Clipboard.setData(ClipboardData(text: response.toString()));
      try {
        final activeOrderResponse = GetActiveOrderResponse.fromJson(response);
        if (activeOrderResponse.status == 200) {
          if (!activeOrderResponse.isBlank) {
            Get.toNamed(Config.ORDER_DETAIL_ROUTE,
                arguments: activeOrderResponse.data.toJson());
          }
        } else {
          message.value = "Failed to fetch active order";
          print("Failed to fetch active order");
        }
      } catch (e) {
        print(e);
        _receiveNewOrders();
        _sendMyLocation();
        final ordersResponse = GetOrdersResponse.fromJson(response);
        if (ordersResponse.status == 200) {
          orders.value.clear();
          if (ordersResponse.data.isNotEmpty) {
            orders.value.addAll(ordersResponse.data);
          } else {
            orders.value.clear();
            message.value = "No Orders Available";
          }
        } else {
          message.value = "Failed to fetch orders";
          print("Failed to fetch orders");
        }
      }
    }, (error) => {print(error)});
  }

  void updateOrderStatus(
      String room, BaseOrderChangeStatusRequest request, OrderData order) {
    _appRepository.updateOrderStatus(room, request, (response) {
      locationTimer?.cancel();
      Get.toNamed(Config.ORDER_DETAIL_ROUTE, arguments: response.data.toJson());
    }, (error) => {print(error)});
  }

  void _sendMyLocation() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      locationTimer = timer;
      _appRepository.sendMyLocation();
    });
  }

  void logOut() {
    _appRepository.logOut();
    Get.offAllNamed(Config.LOGIN_ROUTE);
  }
}
