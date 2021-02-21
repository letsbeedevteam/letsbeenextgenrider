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

  //Routes

  //Colors
  static const LETSBEE_COLOR = 0xFDD96E;

  //Network
  static const BASE_URL = 'https://quiet-meadow-89567.herokuapp.com'; // cloud
  static const NAMESPACE = 'rider';
  // static const BASE_URL = 'http://18.166.234.218:8000'; // staging
  // static const BASE_URL = 'http://192.168.100.14:8000'; // local
  // static const BASE_URL = 'http://192.168.0.17:8000'; // demo
  static const SIGN_IN = '/auth/$NAMESPACE/signin';
  static const REFRESH_ACCESS_TOKEN = '$BASE_URL/auth/$NAMESPACE/refresh-token';
  static const SOCKET = '$BASE_URL/$NAMESPACE';
  static const GET_CURRENT_ORDER = '$BASE_URL/${NAMESPACE}s/current-order';
  static const ACCEPT_ORDER = '$BASE_URL/${NAMESPACE}s/order/choice';
  static const PICKUP_ORDER = '$BASE_URL/${NAMESPACE}s/order/pick-up';
  static const DELIVER_ORDER = '$BASE_URL/${NAMESPACE}s/order/delivered';
  static String getNearbyOrders(
    double lat,
    double lng,
  ) =>
      '$BASE_URL/${NAMESPACE}s/orders/$lat/$lng';
}
