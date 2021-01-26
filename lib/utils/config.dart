class Config {
  //App Name
  static const APP_NAME = "Rider App";

  // Paths
  static const PNG_PATH = 'assets/png/';

  // Storage keys
  static const RIDER_ID = 'id';
  static const RIDER_NAME = "name";
  static const RIDER_EMAIL = "email";
  static const ROLE = "role";
  static const RIDER_CELLPHONE_NUMBER = "cellphone_number";
  static const RIDER_ACCESS_TOKEN = 'access_token';
  static const IS_LOGGEDIN = 'isLoggedIn';

  //Routes
  static const LOGIN_ROUTE = 'login';
  static const DASHBOARD_ROUTE = 'dashboard';
  static const SPLASH_ROUTE = 'splash';
  static const ORDER_DETAIL_ROUTE = "order_detail";
  static const CHAT_ROUTE = "chat";
  static const LOCATION_ROUTE = "location";

  //Colors
  static const LETSBEE_COLOR = 0xFBD10B;

  //Network
  static const BASE_URL =
      'https://serene-caverns-10194.herokuapp.com'; // cloud
  // static const BASE_URL = 'http://192.168.100.14:8000'; // local
  // static const BASE_URL = 'http://192.168.0.17:8000'; // demo
  static const SIGN_IN = '/auth/rider/signin';
  static const REFRESH_ACCESS_TOKEN = '/auth/rider/refresh-token';
  static const SOCKET_NAMESPACE = '/rider';
}
