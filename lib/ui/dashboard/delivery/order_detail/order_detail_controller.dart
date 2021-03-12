import 'dart:async';

import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/product.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailController extends BaseController
    with SingleGetTickerProviderMixin {
  static const CLASS_NAME = 'OrderDetailController';

  final AppRepository _appRepository = Get.find();
  final _argument = Get.arguments;

  Timer _locationTimer;
  List<LocationsRequestData> _locations = List<LocationsRequestData>();
  RxBool hasStartedShopping = false.obs;

  Rx<OrderData> order = OrderData().obs;
  RxString updateOrderStatusButtonText = ''.obs;
  RxString updateOrderStatusdialogTitle = ''.obs;
  RxString updateOrderStatusdialogMessage = ''.obs;
  RxBool isLoading = false.obs;
  RxInt currentOrderStatus = 0.obs;
  List<RxBool> areItemsreadyForCheckout = List<RxBool>();

  // GetxController Overrides
  @override
  void onInit() {
    print('$CLASS_NAME, onInit');
    order.value = OrderData.fromJson(_argument);
    updateUiFromCurrentOrderStatus();
    _initSocket();
    _sendMyOrderLocation();
    super.onInit();
  }

  @override
  void onClose() async {
    print('$CLASS_NAME, onClose');
    await _canceLocationTimer();
    super.onClose();
  }

  // Private Functions
  void _initSocket() async {
    print('$CLASS_NAME, _initSocket');
    await _appRepository.connectSocket()
      ..on('connect', (_) {
        print('connected');
        showSnackbarSuccessMessage(
            'Connected');
        _receiveNewMessages();
      })
      ..on('connecting', (_) {
        print('connecting');
        showSnackbarInfoMessage(
            'Trying to reconnect...');
      })
      ..on('reconnecting', (_) {
        print('reconnecting');
        showSnackbarInfoMessage(
            'Trying to reconnect...');
      })
      ..on('disconnect', (_) {
        print('disconnected');
        showSnackbarErrorMessage('Disconnected. Try refreshing');
      })
      ..on('error', (_) {
        print('socket error = $_');
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

  void pickUpOrder(
    OrderData order,
  ) async {
    isLoading.value = true;
    showSnackbarInfoMessage('Updating status...');
    addDisposableFromFuture(
      await _appRepository.pickupOrder(order.id).then((response) async {
        if (response.data != null) {
          this.order.value = response.data;
          isLoading.value = false;
          updateUiFromCurrentOrderStatus();
          showSnackbarSuccessMessage('Order status updated!');
          // update();
        }
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  void deliverOrder(
    OrderData order,
    List<LocationsRequestData> locations,
  ) async {
    isLoading.value = true;
    showSnackbarInfoMessage('Updating status...');
    addDisposableFromFuture(
      _appRepository.getCurrentPosition().then(
        (currentLocation) {
          _locations.add(LocationsRequestData(
              lat: currentLocation.latitude,
              lng: currentLocation.longitude,
              datetime: DateTime.now().toUtc()));
        },
      ),
    );
    addDisposableFromFuture(
      await _appRepository
          .deliverOrder(order.id, locations)
          .then((response) async {
        if (response.data != null) {
          this.order.value = response.data;
          isLoading.value = false;
          updateUiFromCurrentOrderStatus();
          showSnackbarSuccessMessage('Order status updated!');
          // update();
          goBackToDashboard();
        }
      }).catchError(
        (error) {
          isLoading.value = false;
          showSnackbarErrorMessage((error as Failure).errorMessage);
        },
      ),
    );
  }

  Future<void> _canceLocationTimer() {
    print('$CLASS_NAME, _canceLocationTimer');
    return Future.value({_locationTimer?.cancel()});
  }

  void _sendMyOrderLocation() {
    print('$CLASS_NAME, sendMyOrderLocation');
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      addDisposableFromFuture(
          _appRepository.getCurrentPosition().then((currentLocation) {
        _locations.add(LocationsRequestData(
            lat: currentLocation.latitude,
            lng: currentLocation.longitude,
            datetime: DateTime.now().toUtc()));
        addDisposableFromFuture(
          _appRepository
              .sendCurrentOrderLocation(
                  currentLocation.latitude, currentLocation.longitude)
              .catchError(
                (error) {},
              ),
        );
      }));
    });
  }

  // Public Functions
  void updateOrderStatus() {
    print('$CLASS_NAME, updateOrderStatus');
    if (order.value.store.type == 'mart') {
      switch (currentOrderStatus.value) {
        case 0:
          hasStartedShopping.value = true;
          updateUiFromCurrentOrderStatus();
          break;
        case 1:
          bool isReadyForCheckout = false;
          areItemsreadyForCheckout.forEach((element) {
            isReadyForCheckout = element.value;
          });
          if (isReadyForCheckout) {
            pickUpOrder(order.value);
          } else {
            showSnackbarErrorMessage('Some items are not selected');
          }
          break;
        case 2:
          deliverOrder(order.value, _locations);
          break;
        default:
          goBackToDashboard();
          break;
      }
    } else {
      switch (currentOrderStatus.value) {
        case 0:
          pickUpOrder(order.value);
          break;
        case 1:
          deliverOrder(order.value, _locations);
          break;
        default:
          goBackToDashboard();
          break;
      }
    }
  }

  void updateUiFromCurrentOrderStatus() {
    if (order.value.store.type == 'mart') {
      if (order.value.status == 'rider-accepted' && hasStartedShopping.isTrue) {
        currentOrderStatus.value = 1;
        updateOrderStatusButtonText.value = 'ORDER CHECKED OUT';
        updateOrderStatusdialogTitle.value = 'Order checked out';
        updateOrderStatusdialogMessage.value =
            'Order checked out. This will send a message to the customer that you are on your way.';
      } else if (order.value.status == 'rider-accepted') {
        currentOrderStatus.value = 0;
        updateOrderStatusButtonText.value = 'START SHOPPING';
        updateOrderStatusdialogTitle.value = 'Start shopping';
        updateOrderStatusdialogMessage.value =
            'Start shopping. By confirming to this message. You are in the mart and will start buying the items in the order.';
      } else if (order.value.status == 'rider-picked-up') {
        currentOrderStatus.value = 2;
        updateOrderStatusButtonText.value = 'ORDER DELIVERED';
        updateOrderStatusdialogTitle.value = 'Order delivered';
        updateOrderStatusdialogMessage.value =
            'Order delivered. We will be notified that the delivery is finished.';
      } else if (order.value.status == 'delivered') {
        currentOrderStatus.value = 3;
        updateOrderStatusButtonText.value = 'LOADING..';
        updateOrderStatusdialogTitle.value = '';
        updateOrderStatusdialogMessage.value = '';
      }
    } else {
      if (order.value.status == 'rider-accepted') {
        currentOrderStatus.value = 0;
        updateOrderStatusButtonText.value = 'ORDER PICKED UP';
        updateOrderStatusdialogTitle.value = 'Order picked up';
        updateOrderStatusdialogMessage.value =
            'Order picked up. This will send a message to the customer that you are on your way.';
      } else if (order.value.status == 'rider-picked-up') {
        currentOrderStatus.value = 1;
        updateOrderStatusButtonText.value = 'ORDER DELIVERED';
        updateOrderStatusdialogTitle.value = 'Order delivered';
        updateOrderStatusdialogMessage.value =
            'Order delivered. This will notify us that the delivery is finished.';
      } else if (order.value.status == 'delivered') {
        currentOrderStatus.value = 2;
        updateOrderStatusButtonText.value = 'LOADING..';
        updateOrderStatusdialogTitle.value = '';
        updateOrderStatusdialogMessage.value = '';
      }
    }
  }

  void goBackToDashboard() async {
    print('$CLASS_NAME, goBackToDashboard');
    await _appRepository.disconnectSocket().then((_) {
      Get.back();
    });
  }

  Future<bool> willPopCallback() async {
    print('$CLASS_NAME, willPopCallback');
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }

  void makePhoneCall() async {
    if (order.value.user.cellphoneNumber != null) {
      var uri = 'tel:${order.value.user.cellphoneNumber}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch';
      }
    }
  }

  void showMap() async {
    var dLat;
    var dLong;
    if (order.value.status == 'rider-accepted') {
      dLat = order.value.store.latitude;
      dLong = order.value.store.longitude;
    } else if (order.value.status == 'rider-picked-up') {
      dLat = order.value.address.location.lat;
      dLong = order.value.address.location.lng;
    } else {
      return;
    }

    LocationData currentLocation = await _appRepository.getCurrentPosition();

    var androidGoogleMapUri = 'google.navigation:q=$dLat,$dLong&mode=l';
    var defaultMapUri =
        'http://maps.google.com/maps?saddr=${currentLocation.latitude},${currentLocation.longitude}&daddr=$dLat,$dLong';
    if (await canLaunch(androidGoogleMapUri)) {
      await launch(androidGoogleMapUri);
    } else if (await canLaunch(defaultMapUri)) {
      await launch(defaultMapUri);
    } else {
      print('Could not launch');
    }
  }

  @override
  void onRefresh() async {
    clearDisposables();
    await _appRepository.disconnectSocket();
    await _canceLocationTimer();
    updateUiFromCurrentOrderStatus();
    _initSocket();
    _sendMyOrderLocation();
  }
}
