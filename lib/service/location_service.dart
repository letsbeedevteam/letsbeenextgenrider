import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationService {
  Location _location = Get.find();

  bool _serviceEnabled;
  PermissionStatus _permissionStatus;

  LocationService() {
    _initLocationService();
  }

  void _initLocationService() {
    _initService();
    _initPermission();
  }

  void _initService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  void _initPermission() async {
    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> getCurrentLocation() async =>
      await _location.getLocation();

  Stream<LocationData> onLocationChanged() => _location.onLocationChanged;
}
