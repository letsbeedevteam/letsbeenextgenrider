import 'dart:async';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_active_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_orders_response.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/utils/extensions.dart';

class DashboardController extends GetxController {
  static const CLASS_NAME = 'DashboardController';

  AppRepository _appRepository = Get.find();

  Timer _locationTimer;

  RxBool isLoading = true.obs;
  RxString message = 'Loading...'.obs;
  Rx<RxList<OrderData>> orders = RxList<OrderData>().obs;

  // GetxController Overrides
  @override
  void onInit() {
    print('$CLASS_NAME, onInit');
    _initSocket();
    // refresh token is not working
    // _appRepository.refreshAccessToken().then((_) {
    //   _initSocket();
    // });
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
    _appRepository.connectSocket(
        onConnected: (_) {
          isLoading.value = false;

          _getCurrentActiveOrder();
        },
        onConnecting: (_) {
          isLoading.value = true;
          message.value = 'Connecting';
        },
        onReconnecting: (_) {
          isLoading.value = true;
          message.value = 'Reconnecting';
          _appRepository.refreshAccessToken();
        },
        onDisconnected: (_) {},
        onError: (_) {
          isLoading.value = false;
          message.value = 'Something went wrong';
        });
  }

  void _receiveNewOrders() {
    print('$CLASS_NAME, _receiveNewOrders');
    _appRepository.receiveNewOrder((response) async {
      print('response = $response');
      // Clipboard.setData(ClipboardData(text: response.toString()));
      final orderUpdateResponse = GetNewOrderResponse.fromJson(response);
      if (orderUpdateResponse.isNewOrder()) {
        if (orders.value.isNotEmpty) {
          //checks if the new order is already existing on the list
          //before adding it
          var newOrder = orders.value.firstWhere(
              (order) => order.id == orderUpdateResponse.data.id,
              orElse: () => null);
          if (newOrder != null) {
            return;
          }
        }
        orders.value.add(orderUpdateResponse.data);
        await _appRepository.showNotification(
          title: 'Hi!',
          body:
              "Order No. ${orderUpdateResponse.data.id} is now available for delivery",
          payload: "N/A",
        );
      } else {
        //executed when the received order was an update of an existing order
        //if the received order status update from server is rider-accepted
        //and the received order id matches an order from the list
        //this order would be removed from the list
        var oldOrder = orders.value.firstWhere(
            (order) =>
                orderUpdateResponse.data.status == "rider-accepted" &&
                order.id == orderUpdateResponse.data.id,
            orElse: () => null);
        if (oldOrder != null) {
          orders.value.remove(oldOrder);
        }
      }
    });
  }

  void _sendMyLocation() {
    _appRepository.sendMyLocation();
    print('$CLASS_NAME, _sendMyLocation');
    _locationTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _appRepository.sendMyLocation();
    });
  }

  void _receiveNearbyOrders() {
    print('$CLASS_NAME, _receiveNearbyOrders');
    _appRepository.receiveNearbyOrders((response) {
      print('orderss ${response.toString()}');
      try {
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
      } catch (e) {
        print(e);
      }
    }, (error) => {print(error)});
  }

  void _getCurrentActiveOrder() {
    print('$CLASS_NAME, _getCurrentActiveOrder');
    _appRepository.getCurrentActiveOrder((response) async {
      print(response);
      try {
        final activeOrderResponse = GetActiveOrderResponse.fromJson(response);
        if (activeOrderResponse.status == 200 && activeOrderResponse != null) {
          _goToOrderDetail(arguments: activeOrderResponse.data.toJson());
        } else {
          message.value = "Failed to fetch active order";
          print("Failed to fetch active order");
        }
      } catch (e) {
        print(e);
        _receiveNearbyOrders();
        _receiveNewOrders();
        _sendMyLocation();
        // final ordersResponse = GetOrdersResponse.fromJson(response);
        // if (ordersResponse.status == 200) {
        //   orders.value.clear();
        //   if (ordersResponse.data.isNotEmpty) {
        //     orders.value.addAll(ordersResponse.data);
        //   } else {
        //     orders.value.clear();
        //     message.value = "No Orders Available";
        //   }
        // } else {
        //   message.value = "Failed to fetch orders";
        //   print("Failed to fetch orders");
        // }
      }
    });
  }

  Future<bool> _canceLocationTimer() {
    print('$CLASS_NAME, _canceLocationTimer');
    _locationTimer?.cancel();
    return Future<bool>.value(_locationTimer?.isActive ?? false);
  }

  void _goToOrderDetail({dynamic arguments}) {
    print('$CLASS_NAME, _goToOrderDetail');
    Get.toNamed(Config.ORDER_DETAIL_ROUTE, arguments: arguments).then((_) {
      _initSocket();
    });
  }

  // Public Functions
  void updateOrderStatus(
    String room,
    BaseOrderChangeStatusRequest request,
    OrderData order,
  ) {
    isLoading.value = true;
    print('$CLASS_NAME, updateOrderStatus');
    _appRepository.updateOrderStatus(room, request, (response) async {
      isLoading.value = false;
      if (response.data != null) {
        bool isTimerActive = await _canceLocationTimer();
        if (!isTimerActive) {
          await _appRepository.disconnectSocket().then((isDisconnected) {
            if (isDisconnected) {
              _goToOrderDetail(arguments: response.data.toJson());
            }
          });
        }
      }
    }, (error) {
      isLoading.value = false;
      print(error);
    });
  }

  Future<void> onRefresh() async {
    print('$CLASS_NAME, onRefresh');
    _appRepository.sendMyLocation();
    // bool isTimerActive = await _canceLocationTimer();
    // bool isSocketDisconnected = await _appRepository.disconnectSocket();

    // if (!isTimerActive && isSocketDisconnected) {
    //   _initSocket();
    // }
  }

  void logOut() {
    print('$CLASS_NAME, logOut');
    _appRepository.logOut(
        onSuccess: () {
          Get.offAllNamed(Config.LOGIN_ROUTE);
        },
        onError: (_) => () {
              print('logout error');
            });
  }
}
