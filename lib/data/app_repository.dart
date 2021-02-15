import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/fetch_all_messages_request.dart';
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
import 'package:letsbeenextgenrider/data/models/request/refresh_token_request.dart';
import 'package:letsbeenextgenrider/data/models/request/send_location_request.dart';
import 'package:letsbeenextgenrider/data/models/request/send_message_request.dart';
import 'package:letsbeenextgenrider/data/models/request/send_order_location_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_messages_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_message_response.dart';
import 'package:letsbeenextgenrider/data/models/response/update_order_status_response.dart';
import 'package:letsbeenextgenrider/data/souce/local/sharedpref.dart';
import 'package:letsbeenextgenrider/data/souce/remote/api_service.dart';
import 'package:letsbeenextgenrider/data/souce/remote/socket_service.dart';
import 'package:letsbeenextgenrider/service/google_map_service.dart';
import 'package:letsbeenextgenrider/service/location_service.dart';
import 'package:letsbeenextgenrider/service/push_notification_service.dart';
import 'package:letsbeenextgenrider/utils/google_map_utils.dart';
import 'package:location/location.dart';

class AppRepository {
  ApiService _apiService = Get.find();
  SocketService _socketService = Get.find();
  SharedPref _sharedPref = Get.find();
  LocationService _locationService = Get.find();
  GoogleMapsServices _googleMapsServices = Get.find();
  PushNotificationService _pushNotificationService = Get.find();

// SharedPref
  int getRiderId() => _sharedPref.getRiderId();

// ApiService
  Future login(LoginRequest loginRequest) {
    return _apiService.login(loginRequest).then((response) {
      if (response.status == 200) {
        _sharedPref.saveRiderInfo(
            id: response.data.id,
            name: response.data.name,
            email: response.data.email,
            cellphoneNumber: response.data.cellphoneNumber,
            accessToken: response.data.accessToken,
            role: response.data.role);
      }
    });
  }

  Future refreshAccessToken() {
    RefreshTokenrequest refreshTokenrequest =
        RefreshTokenrequest(_sharedPref.getRiderAccessToken());
    return _apiService.refreshAccessToken(refreshTokenrequest).then((response) {
      if (response.status == 401) {
        _sharedPref.saveRiderAccessToken(response.token);
      }
    });
  }

// SocketService
  void connectSocket(
      {Function(dynamic) onConnected,
      Function(dynamic) onConnecting,
      Function(dynamic) onReconnecting,
      Function(dynamic) onDisconnected,
      Function(dynamic) onError}) {
    _socketService.connectSocket(
        onConnected: onConnected,
        onConnecting: onConnecting,
        onReconnecting: onReconnecting,
        onDisconnected: onDisconnected,
        onError: onError);
  }

  Future<bool> disconnectSocket() {
    _socketService.socket?.close();
    return Future<bool>.value(_socketService.socket.disconnected);
  }

  bool isSocketConnected() {
    return _socketService.isConnected;
  }

  // SocketService - Orders
  //returns a GetActiveOrderResponse if an order is already accepted by THE rider
  //returns a GetOrdersResponse if there is NO order accepted by THE rider
  void receiveNearbyOrders(
    Function(dynamic) success,
    Function(String) failed,
  ) {
    _socketService.socket.on(SocketService.RECEIVE_NEARBY_ORDERS, (response) {
      if (response["status"] == 200) {
        success(response);
      } else {
        failed("Failed to fetch orders");
      }
    });
  }

  void updateOrderStatus(
    String room,
    BaseOrderChangeStatusRequest request,
    Function(UpdateOrderStatusResponse) onSuccess,
    Function(String) onFailed,
  ) {
    _socketService.socket.emitWithAck(room, request.toJson(), ack: (response) {
      print('apprepo, update order status response == $response');
      final updateOrderStatusResponse =
          UpdateOrderStatusResponse.fromJson(response);
      if (updateOrderStatusResponse.status == 200) {
        onSuccess(updateOrderStatusResponse);
      } else {
        onFailed("Failed to update order status");
      }
    });
  }

  void receiveNewOrder(Function(dynamic) onComplete) {
    _socketService.socket.on(SocketService.RECEIVE_NEW_ORDER, (response) {
      print(response);
      onComplete(response);
    });
  }

  void getCurrentActiveOrder(Function(dynamic) onComplete) {
    _socketService.socket.emitWithAck(
        SocketService.GET_CURRENT_ACTIVE_ORDER, '', ack: (response) {
      print(response);
      onComplete(response);
    });
  }

  // // SocketService - Messages
  void fetchAllMessages(
    int orderId,
    Function(GetMessagesResponse) onSuccess,
    Function(String) onFailed,
  ) {
    final request = FetchAllMessagesRequest(orderId: orderId);

    _socketService.socket.emitWithAck(
        SocketService.FETCH_ALL_MESSAGES, request.toJson(), ack: (response) {
      print(response);
      final getMessagesResponse = GetMessagesResponse.fromJson(response);
      if (getMessagesResponse.status == 200) {
        onSuccess(getMessagesResponse);
      } else {
        print("Failed to fetch all messages");
        onFailed("Failed to fetch all messages");
      }
    });
  }

  void sendMessage(
    int orderId,
    int customerUserId,
    String message, {
    Function(GetNewMessageResponse) onComplete,
  }) {
    print('sending message');
    var request = SendMessageRequest(
        orderId: orderId, customerUserId: customerUserId, message: message);

    _socketService.socket.emitWithAck(
        SocketService.SEND_MESSAGE, request.toJson(), ack: (response) {
      print(response);
      final getNewMessageResponse = GetNewMessageResponse.fromJson(response);
      onComplete(getNewMessageResponse);
    });
  }

  void receiveNewMessages(Function(GetNewMessageResponse) onComplete) {
    _socketService.socket.on(SocketService.RECEIVE_NEW_MESSAGES, (response) {
      print(response);
      final getNewMessageResponse = GetNewMessageResponse.fromJson(response);
      onComplete(getNewMessageResponse);
    });
  }

  // Locations
  void sendMyLocation() {
    print("sending my location");
    getCurrentPosition().then((currentLocation) {
      if (currentLocation != null) {
        final request = SendLocationRequest(
            location: LocationRequestData(
          lat: currentLocation.latitude,
          lng: currentLocation.longitude,
        ));
        print(request.toJson());
        _socketService.socket
            .emit(SocketService.SEND_LOCATION, request.toJson());
      }
    });
  }

  void sendMyOrderLocation(int userId, int orderId) {
    print("sending my order location");
    getCurrentPosition().then((currentLocation) {
      if (currentLocation != null) {
        final request = SendOrderLocationRequest(
            location: OrderLocationRequestData(
                lat: currentLocation.latitude, lng: currentLocation.longitude),
            userId: userId,
            orderId: orderId);
        _socketService.socket
            .emit(SocketService.SEND_ORDER_LOCATION, request.toJson());
      }
    });
  }

// Location
  Future<LocationData> getCurrentPosition() async =>
      await _locationService.getCurrentLocation();

// GoogleMapsServices
  Future<List<LatLng>> getRouteCoordinates(
      {LatLng source, LatLng destination}) async {
    return await _googleMapsServices
        .getRouteCoordinates(source, destination)
        .then((encodedPoly) {
      print(encodedPoly);
      List<LatLng> points = List<LatLng>();
      if (!encodedPoly.isBlank) {
        points = convertToLatLng(decodePoly(encodedPoly));
      }
      return points;
    });
  }

  Future<void> showNotification({String title, String body, String payload}) {
    return _pushNotificationService.showNotification(
        title: title, body: body, payload: payload);
  }

  void logOut({Function onSuccess, Function onError(dynamic error)}) {
    disconnectSocket().then((isDisconnected) {
      _sharedPref.clearUserInfo();
      onSuccess();
    }, onError: (_) {
      onError(_);
    });
  }
}
