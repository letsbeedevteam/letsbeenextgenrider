import 'dart:async';

import 'package:get/get.dart';
import 'package:location/location.dart';

mixin LocationDetector {
  Location _location = Get.find();
  StreamSubscription<LocationData> _subscription;

  void initUpdateLocation() {
    _subscription = _location.onLocationChanged.listen((locationData) {
      onLocationUpdate(locationData);
    });
    _location.serviceEnabled();
  }

  void stopUpdateLocation() {
    _subscription.cancel();
  }

  void onLocationUpdate(LocationData locationData);
}
