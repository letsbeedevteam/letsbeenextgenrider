import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_refresh_controller.dart';
import 'package:letsbeenextgenrider/core/utils/extensions.dart';

class DeliveryController extends BaseRefreshController {
  static const CLASS_NAME = 'DeliveryController';

  final AppRepository appRepository;

  DeliveryController({@required this.appRepository});

  RxString statusMessage = 'Loading...'.obs;
  Rx<MaterialColor> statusColor = Colors.orange.obs;

  Timer _locationTimer;
  Rx<RxList<OrderData>> orders = RxList<OrderData>().obs;

  @override
  void onInit() async {
    print('$CLASS_NAME, onInit');
    _getCurrentOrder();
    super.onInit();
  }

  void _initOrderslist() {
    isLoading.value = true;
    _getNearbyOrders().then((_) {
      isLoading.value = false;
      _getOrdersEvery30Secs();
    });
  }

  @override
  void onClose() async {
    print('$CLASS_NAME, onClose');
    await _canceLocationTimer();
    await appRepository.disconnectSocket();
    super.onClose();
  }

  void _getCurrentOrder() async {
    await appRepository.getCurrentOrder().then((response) {
      if (response.data != null) {
        _goToOrderDetail(arguments: response.data.toJson());
      } else {
        _initSocket();
        _initOrderslist();
      }
    });
  }

  Future<void> _getNearbyOrders() async {
    return appRepository.getCurrentPosition().then((position) async {
      await appRepository
          .getNearbyOrders(position.latitude, position.longitude)
          .then((response) {
        orders.value.clear();
        orders.value.addAll(response.data);
        message.value = orders.value.isEmpty ? 'No Orders Available' : '';
      });
    }).catchError((error) {
      message.value = (error as Failure).errorMessage;
      print('${(error as Failure).errorMessage}');
    });
  }

  // Private Functions
  void _initSocket() async {
    print('$CLASS_NAME, _initSocket');
    await appRepository.connectSocket()
      ..on('connect', (_) {
        print('connected');
        statusMessage.value = 'Connected';
        statusColor.value = Colors.green;

        Future.delayed(Duration(seconds: 3)).then((_) {
          statusMessage.value = '';
        });
        _receiveNewOrders();
      })
      ..on('connecting', (_) {
        print('connecting');
        statusMessage.value = 'Connecting';
        statusColor.value = Colors.orange;
      })
      ..on('reconnecting', (_) {
        print('reconnecting');
        statusMessage.value = 'Reconnecting';
        statusColor.value = Colors.orange;
      })
      ..on('disconnect', (_) {
        print('disconnected');
        statusMessage.value = 'Disconnected';
        statusColor.value = Colors.red;
      })
      ..on('error', (_) {
        statusMessage.value = 'Something went wrong';
        statusColor.value = Colors.red;
        print('socket error = $_');
      });
  }

  void _receiveNewOrders() {
    print('$CLASS_NAME, _receiveNewOrders');
    appRepository.receiveNewOrder((response) async {
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
        await appRepository.showNotification(
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

  void _getOrdersEvery30Secs() async {
    print('$CLASS_NAME, _getOrdersEvery30Secs');
    await _canceLocationTimer().then((_) {
      _locationTimer = Timer.periodic(Duration(seconds: 30), (_) async {
        await _getNearbyOrders();
      });
    });
  }

  Future<void> _canceLocationTimer() async {
    print('$CLASS_NAME, _canceLocationTimer');
    _locationTimer?.cancel();
  }

  void _goToOrderDetail({dynamic arguments}) {
    print('$CLASS_NAME, _goToOrderDetail');
    Get.toNamed(Routes.ORDER_DETAIL_ROUTE, arguments: arguments).then((_) {
      _initSocket();
      _initOrderslist();
    });
  }

  // Public Functions
  void acceptOrder(
    OrderData order,
  ) async {
    await appRepository.acceptOrder(order.id).then((response) async {
      if (response.data != null) {
        await _canceLocationTimer();
        await appRepository.disconnectSocket();
        _goToOrderDetail(arguments: response.data.toJson());
      }
    }).catchError((error) {
      statusMessage.value = '${(error as Failure).errorMessage}';
      statusColor.value = Colors.red;
    });
  }

  @override
  Future<void> onRefresh() async {
    print('$CLASS_NAME, onRefresh');
    _initOrderslist();
  }
}
