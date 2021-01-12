import 'dart:async';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_active_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_orders_response.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/utils/utils.dart';

class DashboardController extends GetxController{
  static DashboardController get to => Get.find();
  AppRepository _appRepository = Get.find();

  var isLoading = true.obs;
  var message = 'Loading...'.obs;
  var orders = RxList<OrderData>().obs;

  Timer locationTimer;

  // View Functions
  @override
  void onInit() {
    initSocket();
    super.onInit();
  }

  @override
  void onClose() {
    _disconnectSocket();
    locationTimer?.cancel();
    super.onClose();
  }

  // Private Functions
  void initSocket() {
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
    _appRepository.receiveNewOrder((response) async {
      ///identify if the [response] was an update of an existing order or a completely new order
      ///if the received order is new, show notification and add the order to [orders] list
      ///else if the received order is an update, modify the order in the [orders] list

      if (isNewOrder(response)) {
        final orderResponse = OrderData.fromJson(response);
        if (orders.value.isNotEmpty) {
          var newOrder = orders.value.firstWhere(
              (order) => order.id == orderResponse.id,
              orElse: () => null);
          if (newOrder == null) {
            orders.value.add(orderResponse);
          }
        } else {
          orders.value.add(orderResponse);
        }
        await _appRepository.showNotification(
            title: 'Hi!',
            body:
                "Order No. ${orderResponse.id} is now available for delivery");
      } else if (isUpdatedOrder(response)) {
        final orderUpdate = GetNewOrderResponse.fromJson(response);
        orders.value.map((order) => {
              if (order.id == orderUpdate.data.id) {order = orderUpdate.data}
            });
        orders.value.refresh();
      } else {
        print(
            "Error cannot be converted to neither Order nor NewOrderResponse");
      }
    });
  }

  void _sendMyLocation() {
    locationTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _appRepository.sendMyLocation();
    });
  }

  Future _disconnectSocket() {
    _appRepository.disconnectSocket();
    return Future.value(_appRepository.isSocketConnected());
  }

  // Public Functions
  void fetchAllOrders() {
    _appRepository.fetchAllOrders((response) {
      print(response.toString());
      try {
        final activeOrderResponse = GetActiveOrderResponse.fromJson(response);
        if (activeOrderResponse.status == 200 && activeOrderResponse != null) {
          Get.toNamed(Config.ORDER_DETAIL_ROUTE,
              arguments: activeOrderResponse.data.toJson());
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
    String room,
    BaseOrderChangeStatusRequest request,
    OrderData order,
  ) async {
    var isTimerActive = await canceLocationTimer();

    if (!isTimerActive) {
      _appRepository.updateOrderStatus(room, request, (response) async {
        var isSocketConnected = await _disconnectSocket();
        if (!isSocketConnected) {
          Get.toNamed(Config.ORDER_DETAIL_ROUTE,
              arguments: response.data.toJson());
        }
      }, (error) {
        _sendMyLocation();
        print(error);
      });
    }
  }

  Future canceLocationTimer() {
    locationTimer.cancel();
    return Future<bool>.value(locationTimer.isActive);
  }

  void logOut() {
    _appRepository.logOut();
    Get.offAllNamed(Config.LOGIN_ROUTE);
  }

  @override
  void onSelectNotification(String payload) {
    // TODO: implement onSelectNotification
  }
}
