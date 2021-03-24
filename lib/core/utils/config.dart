import 'package:flutter/foundation.dart';

class Config {
  //App Name
  static const APP_NAME = "Rider App";

  // Paths
  static const PNG_PATH = 'assets/png/';
  static const SVG_PATH = 'assets/svg/';

  // Storage keys
  static const RIDER_ID = 'id';
  static const RIDER_NAME = "name";
  static const RIDER_EMAIL = "email";
  static const ROLE = "role";
  static const RIDER_CELLPHONE_NUMBER = "cellphone_number";
  static const RIDER_ACCESS_TOKEN = 'access_token';
  static const IS_LOGGEDIN = 'isLoggedIn';
  
  //Colors
  static const LETSBEE_COLOR = 0xFDD96E;

  //Network
  // static const BASE_URL = 'https://quiet-meadow-89567.herokuapp.com'; // cloud
  static const NAMESPACE = 'rider';
  static const BASE_URL = 'http://18.166.234.218:8080'; // staging
  // static const BASE_URL = 'http://192.168.0.100:8000'; // local
  // static const BASE_URL = 'http://192.168.0.17:8000'; // demo
  static const SIGN_IN = '/auth/$NAMESPACE/signin';
  static const REFRESH_ACCESS_TOKEN = '$BASE_URL/auth/$NAMESPACE/refresh-token';
  static const SOCKET = '$BASE_URL/$NAMESPACE';
  static const GET_CURRENT_ORDER = '$BASE_URL/${NAMESPACE}s/current-order';
  static const ACCEPT_ORDER = '$BASE_URL/${NAMESPACE}s/order/choice';
  static const PICKUP_ORDER = '$BASE_URL/${NAMESPACE}s/order/pick-up';
  static const DELIVER_ORDER = '$BASE_URL/${NAMESPACE}s/order/delivered';
  static const UPDATE_WORK_STATUS = '$BASE_URL/${NAMESPACE}s/status';
  static const SEND_CURRENT_LOCATION_ORDER =
      '$BASE_URL/${NAMESPACE}s/order/location';
  static String getNearbyOrders(
    double lat,
    double lng,
  ) =>
      '$BASE_URL/${NAMESPACE}s/orders/$lat/$lng';

  /// Date format should follow Date Format = YYYY-MM-DD HH:mm:ii
  /// ex. 2021-02-25%2000:00:00
  static String getStatsByDate({
    @required String from,
    @required String to,
  }) =>
      '$BASE_URL/${NAMESPACE}s/stats?from=$from&to=$to';

  /// Date format should follow Date Format = YYYY-MM-DD HH:mm:ii
  /// status can be "rider-accepted", "rider-picked-up" or "delivered"
  /// ex. 2021-02-25%2000:00:00&status=delivered
  static String getHistoryByDateAndStatus({
    @required String from,
    @required String to,
    @required int page,
  }) =>
      '$BASE_URL/${NAMESPACE}s/history?page=$page&from=$from&to=$to';
}
