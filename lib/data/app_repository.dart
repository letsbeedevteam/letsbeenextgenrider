import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/data/models/request/base/base_order_change_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/fetch_all_messages_request.dart';
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
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
import 'package:letsbeenextgenrider/utils/google_map_utils.dart';
import 'package:location/location.dart';

class AppRepository {
  ApiService _apiService = Get.find();
  SocketService _socketService = Get.find();
  SharedPref _sharedPref = Get.find();
  Location _location = Get.find();
  GoogleMapsServices _googleMapsServices = Get.find();

  int getRiderId() => _sharedPref.getRiderId();

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

  void disconnectSocket() {
    _socketService.socket.close();
  }

  void fetchAllOrders(
    Function(dynamic) success,
    Function(String) failed,
  ) {
    _socketService.socket.emitWithAck(SocketService.FETCH_ALL_ORDERS, '',
        ack: (response) {
      if (response["status"] == 200) {
        success(response);
      } else {
        failed("Failed to fetch orders");
      }
    });
  }

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
    String message,
  ) {
    print('sending message');
    var request = SendMessageRequest(
        orderId: orderId, customerUserId: customerUserId, message: message);

    _socketService.socket.emit(SocketService.SEND_MESSAGE, request.toJson());
  }

  void updateOrderStatus(
    String room,
    BaseOrderChangeStatusRequest request,
    Function(UpdateOrderStatusResponse) onSuccess,
    Function(String) onFailed,
  ) {
    _socketService.socket.emitWithAck(room, request.toJson(), ack: (response) {
      final updateOrderStatusResponse =
          UpdateOrderStatusResponse.fromJson(response);
      if (updateOrderStatusResponse.status == 200) {
        onSuccess(updateOrderStatusResponse);
      } else {
        onFailed("Failed to update order status");
      }
    });
  }

  void receiveNewOrder(Function() onComplete) {
    _socketService.socket.on(SocketService.RECEIVE_NEW_ORDER, (response) {
      onComplete();
    });
  }

  void receiveNewMessages(Function(GetNewMessageResponse) onComplete) {
    _socketService.socket.on(SocketService.RECEIVE_NEW_MESSAGES, (response) {
      print(response);
      final getNewMessageResponse = GetNewMessageResponse.fromJson(response);
      onComplete(getNewMessageResponse);
    });
  }

  void sendMyLocation() {
    print("sending my location");
    getCurrentPosition().then((currentLocation) {
      final request = SendLocationRequest(
          location: LocationRequestData(
              lat: currentLocation.latitude, lng: currentLocation.longitude));
      _socketService.socket.emit(SocketService.SEND_LOCATION, request.toJson());
    });
  }

  void sendMyOrderLocation(int userId) {
    print("sending my order location");
    getCurrentPosition().then((currentLocation) {
      final request = SendOrderLocationRequest(
          location: OrderLocationRequestData(
              lat: currentLocation.latitude, lng: currentLocation.longitude),
          userId: userId);
      _socketService.socket
          .emit(SocketService.SEND_ORDER_LOCATION, request.toJson());
    });
  }

  Future<LocationData> getCurrentPosition() async =>
      await _location.getLocation();

  Future<List<LatLng>> getRouteCoordinates(
      {LatLng source, LatLng destination}) async {
    return await _googleMapsServices
        .getRouteCoordinates(source, destination)
        .then((encodedPoly) => convertToLatLng(decodePoly(encodedPoly)));
  }

  void logOut() {
    disconnectSocket();
    _sharedPref.clearUserInfo();
  }
}
