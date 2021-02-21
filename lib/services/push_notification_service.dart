import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/routing/pages.dart';
class PushNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializesationSettings;

  PushNotificationService() {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    _init();
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
    initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    initializationSettingsIOS = IOSInitializationSettings();
    initializesationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializesationSettings,
        onSelectNotification: _onSelectionNotification);
  }

  Future _onSelectionNotification(String payload) async {
    if (payload != null) {
      if (isOrderData(payload)) {
        var orderData = orderDataFromJson(payload);
        Get.toNamed(Routes.CHAT_ROUTE, arguments: orderData.toJson());
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
