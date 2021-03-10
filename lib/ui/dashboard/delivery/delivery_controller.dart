import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';
import 'package:letsbeenextgenrider/core/utils/extensions.dart';

class DeliveryController extends BaseController
    with SingleGetTickerProviderMixin {
  static const CLASS_NAME = 'DeliveryController';

  final AppRepository appRepository;

  DeliveryController({@required this.appRepository});

  Timer _locationTimer;
  Rx<RxList<OrderData>> orders = RxList<OrderData>().obs;

  @override
  void onInit() async {
    print('$CLASS_NAME, onInit');
    _getCurrentOrder();
    super.onInit();
  }

  @override
  void onClose() async {
    print('$CLASS_NAME, onClose');
    await _canceLocationTimer();
    await appRepository.disconnectSocket();
    super.onClose();
  }

  // Private Functions
  void _initSocket() async {
    print('$CLASS_NAME, _initSocket');
    await appRepository.connectSocket()
      ..on('connect', (_) {
        print('connected');
        showSnackbarSuccessMessage(
            'YOU ARE NOW CONNECTED AND WILL RECEIVE ORDERS');
        _receiveNewOrders();
      })
      ..on('connecting', (_) {
        print('connecting');
        showSnackbarSuccessMessage(
            'LOST CONNECTION! TRYING TO RECONNECT PLEASE WAIT...');
      })
      ..on('reconnecting', (_) {
        print('reconnecting');
        showSnackbarSuccessMessage(
            'LOST CONNECTION! TRYING TO RECONNECT PLEASE WAIT...');
      })
      ..on('disconnect', (_) {
        print('disconnected');
        showSnackbarErrorMessage('YOU WERE DISCONNECTED! TRY TO REFRESH');
      })
      ..on('error', (_) {
        print('socket error = $_');
      });
  }

  void _getCurrentOrder() async {
    showSnackbarInfoMessage('CHECKING CURRENT ORDER PLEASE WAIT...');
    await appRepository.getCurrentOrder().then((response) {
      if (response.data != null) {
        showSnackbarInfoMessage('Loading current order...');
        _goToOrderDetail(arguments: response.data.toJson());
      } else {
        _initSocket();
        _getOrdersEvery30Secs();
      }
    }).catchError((error) {
      showSnackbarErrorMessage((error as Failure).errorMessage);
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
      }).catchError((error) {
        showSnackbarErrorMessage((error as Failure).errorMessage);
      });
    }).catchError((error) {
      showSnackbarErrorMessage((error as Failure).errorMessage);
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
        //when the received order was an update of an existing order and
        //the received order status update from server was rider-accepted
        //and order id matches an order id from the list
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
      message.value = orders.value.isEmpty ? 'No Orders Available' : '';
    });
  }

  void _getOrdersEvery30Secs() async {
    print('$CLASS_NAME, _getOrdersEvery30Secs');
    _getNearbyOrders();
    await _canceLocationTimer().then((_) {
      _locationTimer = Timer.periodic(Duration(seconds: 30), (_) async {
        isShownSnackbar.value = false;
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
      _getOrdersEvery30Secs();
    });
  }

  // Public Functions
  void acceptOrder(
    OrderData orderData,
  ) async {
    await appRepository.acceptOrder(orderData.id).then((response) async {
      if (response.data != null) {
        await _canceLocationTimer();
        await appRepository.disconnectSocket();
        showSnackbarInfoMessage('LOADING ORDER INFO...');
        _goToOrderDetail(arguments: response.data.toJson());
        var acceptedOrder = orders.value.firstWhere(
            (order) => order.id == orderData.id,
            orElse: () => null);
        if (acceptedOrder != null) {
          orders.value.remove(acceptedOrder); 
        }
      }
    }).catchError((error) {
      showSnackbarErrorMessage((error as Failure).errorMessage);
    });
  }

  @override
  Future<void> onRefresh() async {
    print('$CLASS_NAME, onRefresh');
    await appRepository.disconnectSocket();
    _getCurrentOrder();
  }

  @override
  void onViewVisible() {
    onInit();
    super.onViewVisible();
  }

  @override
  void onViewHide() {
    onClose();
    super.onViewHide();
  }
}
