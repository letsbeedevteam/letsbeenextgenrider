import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/utils/utils.dart';

class PushNotificationService extends GetxController {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializesationSettings;

  @override
  void onInit() async{
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
     _init();
    super.onInit();
  }

  void initialize() async{
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
     _init();
    super.onInit();
  }

  void _requestIOSPermission() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _init() {
    initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = IOSInitializationSettings();
    initializesationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializesationSettings,
        onSelectNotification: onSelectionNotification);
  }

  Future onSelectionNotification(String payload) async {
    print('Notification payload: $payload');
    if (payload != null) {
      if (isOrderData(payload)) {
        var orderData = orderDataFromJson(payload);
        Get.toNamed(Config.CHAT_ROUTE, arguments: orderData.toJson());
      }
    }
  }

  Future<void> showNotification(
      {String title, String body, String payload}) async {
    var androidPlatformChannel = AndroidNotificationDetails(
        'Customer Channel ID', 'Customer App', 'Customer Notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        ticker: 'test ticker');

    var iosPlatform = IOSNotificationDetails();
    var platform =
        NotificationDetails(android: androidPlatformChannel, iOS: iosPlatform);
    await _flutterLocalNotificationsPlugin.show(
        Random().nextInt(pow(2, 31) - 1), title, body, platform,
        payload: payload);
  }
}
