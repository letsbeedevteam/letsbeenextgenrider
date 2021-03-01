import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/data/souce/local/sharedpref.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  // Events
  static const RECEIVE_NEARBY_ORDERS = 'orders';
  static const RECEIVE_NEW_ORDER = 'order';
  static const GET_CURRENT_ACTIVE_ORDER = 'current-order';
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

  Future<IO.Socket> connectSocket() async {
    this.socket = IO.io(Config.SOCKET, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {
        'x-auth-token': _sharedPref.read(SharedPref.RIDER_ACCESS_TOKEN)
      }
    });

    return this.socket;
  }
}
