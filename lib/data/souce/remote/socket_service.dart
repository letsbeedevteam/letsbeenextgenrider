import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxController {
  // Events
  static const FETCH_ALL_ORDERS = 'orders';
  static const RECEIVE_NEW_ORDER = 'order';
  static const UPDATE_ORDER_STATUS_TO_RIDER_ACCEPTED = '';
  static const UPDATE_ORDER_STATUS_TO_RIDER_PICK_UP = '';
  static const UPDATE_ORDER_STATUS_TO_DELIVERED = '';
  static const SEND_LOCATION = 'location';
  static const SEND_ORDER_LOCATION = 'order-location';
  static const RECEIVE_NEW_MESSAGES = 'order-chat';
  static const FETCH_ALL_MESSAGES = 'order-chats';
  static const SEND_MESSAGE = 'message-customer';

  //Socket Events
  static const CONNECTED = 'connect';
  static const CONNECTING = 'connecting';
  static const RECONNECTING = 'reconnecting';
  static const DISCONNECTED = 'disconnect';
  static const ERROR = 'error';

  final GetStorage _sharedPref = Get.find();

  IO.Socket socket;

  bool isConnected;

  void connectSocket(
      {Function(dynamic) onConnected,
      Function(dynamic) onConnecting,
      Function(dynamic) onReconnecting,
      Function(dynamic) onDisconnected,
      Function(dynamic) onError}) {
    this.socket =
        IO.io(Config.BASE_URL + Config.SOCKET_NAMESPACE, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {
        'x-auth-token': _sharedPref.read(Config.RIDER_ACCESS_TOKEN)
      }
    });

    // this.socket.connect();

    this.socket
      ..on(CONNECTED, (_) {
        print('connected');
        isConnected = true;
        onConnected(_);
      })
      ..on(CONNECTING, (_) {
        print('connecting');
         isConnected = false;
        onConnecting(_);
      })
      ..on(RECONNECTING, (_) {
        print('reconnecting');
        isConnected = false;
        onReconnecting(_);
      })
      ..on(DISCONNECTED, (_) {
        print('disconnected');
        isConnected = false;
        onDisconnected(_);
      })
      ..on(ERROR, (_) {
        print('socket error = $_');
        isConnected = false;
        onError(_);
      });
  }
}
