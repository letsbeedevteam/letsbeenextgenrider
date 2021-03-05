import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/data/models/motorcycle_details.dart';

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
  static const PHOTO = 'photo';
  static const MOTORCYCLE_BRAND = 'motorcycle_brand';
  static const MOTORCYCLE_MODEL = 'motorcycle_model';
  static const MOTORCYCLE_COLOR = 'motorcycle_color';
  static const MOTORCYCLE_PLATE_NUMBER = 'motorcycle_plate_number';

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

  void savePhoto(String photo) {
    _getStorage.write(PHOTO, photo);
  }

  void saveMotorCycleBrand(String brand) {
    _getStorage.write(MOTORCYCLE_BRAND, brand);
  }

  void saveMotorCycleModel(String model) {
    _getStorage.write(MOTORCYCLE_MODEL, model);
  }

  void saveMotorCycleColor(String color) {
    _getStorage.write(MOTORCYCLE_COLOR, color);
  }

  void saveMotorCyclePlateNumber(String plateNumber) {
    _getStorage.write(MOTORCYCLE_PLATE_NUMBER, plateNumber);
  }

  void saveRiderInfo({
    int id,
    String name,
    String email,
    String cellphoneNumber,
    String accessToken,
    String role,
    String photo,
    String brand,
    String model,
    String color,
    String plateNumber,
  }) {
    saveRiderId(id);
    saveRiderName(name);
    saveRiderEmail(email);
    saveRiderCellphoneNumber(cellphoneNumber);
    saveRiderAccessToken(accessToken);
    saveRole(role);
    savePhoto(photo);
    saveMotorCycleBrand(brand);
    saveMotorCycleModel(model);
    saveMotorCycleColor(color);
    saveMotorCyclePlateNumber(plateNumber);
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

  String getPhoto() {
    return _getStorage.read(PHOTO);
  }

  String getMotorcycleBrand(){
    return _getStorage.read(MOTORCYCLE_BRAND);
  }

  String getMotorcycleModel(){
    return _getStorage.read(MOTORCYCLE_MODEL);
  }

  String getMotorcycleColor(){
    return _getStorage.read(MOTORCYCLE_COLOR);
  }

  String getMotorcyclePlateNumber(){
    return _getStorage.read(MOTORCYCLE_PLATE_NUMBER);
  }

  // Storage functions
  void clearUserInfo() {
    _getStorage.erase();
  }
}
