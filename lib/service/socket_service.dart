import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxController {
  final GetStorage _box = Get.find();

  IO.Socket socket;

  void connectSocket() {
    this.socket =
        IO.io(Config.BASE_URL + Config.SOCKET_NAMESPACE, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'x-auth-token': _box.read(Config.RIDER_ACCESS_TOKEN)}
    });

    this.socket.connect();

    // this.socket.on("connect", (_) => print('Connected'));
    // this.socket.on("connecting", (_) => print('Connecting'));
    // this.socket.on("reconnecting", (_) => print('Reconnecting'));
    // this.socket.on("disconnect", (_) => print('Disconnected: $_'));
    // this.socket.on("connect_error", (_) => print('Connect error: $_'));
    // this.socket.on("connect_timeout", (_) => print('Connect timeout: $_'));
    // this.socket.on("error", (_) => print('Error: $_'));
  }

  void disconnectSocket() => this.socket.disconnect();
}
