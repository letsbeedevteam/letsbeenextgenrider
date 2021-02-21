import 'dart:async';

import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/error/base/failure.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/pick_up_order_request.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailController extends GetxController {
  static const CLASS_NAME = 'OrderDetailController';

  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;
  Timer _locationTimer;
  List<LocationsRequestData> _locations = List<LocationsRequestData>();

  Rx<OrderData> order = OrderData().obs;
  RxString updateOrderStatusButtonText = 'Marked as Picked-Up'.obs;
  RxBool isLoading = false.obs;

  // GetxController Overrides
  @override
  void onInit() {
    print('$CLASS_NAME, onInit');
    order.value = OrderData.fromJson(_argument);
    _initSocket();
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
    // _appRepository.connectSocket(onConnected: (_) {
    //   _sendMyOrderLocation();
    //   _receiveNewMessages();
    //   isLoading.value = false;
    // }, onConnecting: (_) {
    //   isLoading.value = true;
    // }, onReconnecting: (_) {
    //   isLoading.value = true;
    // }, onDisconnected: (_) {
    //   isLoading.value = true;
    // }, onError: (_) {
    //   isLoading.value = false;
    // });
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
    await _appRepository.pickupOrder(order.id).then((response) async {
      if (response.data != null) {
        this.order.value = response.data;
        isLoading.value = false;
      }
    }).catchError((error) {
      print('${(error as Failure).errorMessage}');
      isLoading.value = false;
    });
  }

  void deliverOrder(
    OrderData order,
    List<LocationsRequestData> locations,
  ) async {
    isLoading.value = true;
    _appRepository.getCurrentPosition().then((currentLocation) {
        _locations.add(LocationsRequestData(
            lat: currentLocation.latitude,
            lng: currentLocation.longitude,
            datetime: DateTime.now().toUtc()));
      });
    await _appRepository
        .deliverOrder(order.id, locations)
        .then((response) async {
      if (response.data != null) {
        this.order.value = response.data;
        isLoading.value = false;
      }
    }).catchError((error) {
      print('${(error as Failure).errorMessage}');
      isLoading.value = false;
    });
  }

  Future _canceLocationTimer() {
    print('$CLASS_NAME, _canceLocationTimer');
    return Future.value({_locationTimer?.cancel()});
  }

  void _sendMyOrderLocation() {
    print('$CLASS_NAME, sendMyOrderLocation');
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _appRepository.getCurrentPosition().then((currentLocation) {
        _locations.add(LocationsRequestData(
            lat: currentLocation.latitude,
            lng: currentLocation.longitude,
            datetime: DateTime.now().toUtc()));

        _appRepository.sendMyOrderLocation(order.value.userId, order.value.id);
      });
    });
  }

  // Public Functions
  void updateOrderStatus() {
    print('$CLASS_NAME, updateOrderStatus');
    switch (order.value.status) {
      case 'rider-accepted':
        {
          pickUpOrder(order.value);
        }
        break;
      case 'rider-picked-up':
        {
          deliverOrder(order.value, _locations);
        }
        break;
      default:
        {
          isLoading.value = false;
          //this should be refactored
          //this will/should never be called
          Get.back();
        }
        break;
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

  Future<void> makePhoneCall() async {
    var uri = 'tel:${order.value.user.cellphoneNumber}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch';
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
      throw 'Could not launch';
    }
  }
}
