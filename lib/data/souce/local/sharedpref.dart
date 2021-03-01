import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SharedPref {
  final GetStorage _getStorage = Get.find();
  // Storage keys
  static const RIDER_ID = 'id';
  static const RIDER_NAME = "name";
  static const RIDER_EMAIL = "email";
  static const ROLE = "role";
  static const RIDER_CELLPHONE_NUMBER = "cellphone_number";
  static const RIDER_ACCESS_TOKEN = 'access_token';
  static const IS_LOGGEDIN = 'isLoggedIn';

  // Storage write functions
  void saveRiderId(int riderId) {
    _getStorage.write(RIDER_ID, riderId);
  }

  void saveRiderName(String riderName) {
    _getStorage.write(RIDER_NAME, riderName);
  }

  void saveRiderEmail(String riderEmail) {
    _getStorage.write(RIDER_EMAIL, riderEmail);
  }

  void saveRiderCellphoneNumber(String riderCellphoneNumber) {
    _getStorage.write(RIDER_CELLPHONE_NUMBER, riderCellphoneNumber);
  }

  void saveRiderAccessToken(String riderAccessToken) {
    _getStorage.write(RIDER_ACCESS_TOKEN, riderAccessToken);
  }

  void saveRole(String role) {
    _getStorage.write(ROLE, role);
  }

  void saveRiderInfo(
      {int id,
      String name,
      String email,
      String cellphoneNumber,
      String accessToken,
      String role}) {
    saveRiderId(id);
    saveRiderName(name);
    saveRiderEmail(email);
    saveRiderCellphoneNumber(cellphoneNumber);
    saveRiderAccessToken(accessToken);
    saveRole(role);
  }

  // Storage read functions
  int getRiderId() {
    return _getStorage.read(RIDER_ID);
  }

  String getRiderName() {
    return _getStorage.read(RIDER_NAME);
  }

  String getRiderEmail() {
    return _getStorage.read(RIDER_EMAIL);
  }

  String getRiderCellphoneNumber() {
    return _getStorage.read(RIDER_CELLPHONE_NUMBER);
  }

  String getRiderAccessToken() {
    return _getStorage.read(RIDER_ACCESS_TOKEN);
  }

  String getRole() {
    return _getStorage.read(ROLE);
  }

  // Storage functions
  void clearUserInfo() {
    _getStorage.erase();
  }
}
