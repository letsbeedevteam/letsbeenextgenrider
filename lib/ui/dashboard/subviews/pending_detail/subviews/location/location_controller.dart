import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class LocationController extends GetxController
    with SingleGetTickerProviderMixin {
  static const CLASS_NAME = 'LocationController';

  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;

  AnimationController controller;
  Animation<double> animation;
  OrderData order;
  LatLng initialcameraposition = LatLng(15.162884, 120.5566405);
  Completer<GoogleMapController> _completer = Completer();
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  List<LatLng> _routeCoordinates = List();
  LatLng _restaurantCoordinates;
  LatLng _customerCoordinates;
  bool isCameraMoving = false;

  Timer _locationTimer;

  // double _locationHeading = 0.0;

  @override
  void onInit() {
    print('$CLASS_NAME, onInit');
    order = OrderData.fromJson(_argument);

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInBack);

    _restaurantCoordinates = LatLng(
      double.parse(order.restaurant.latitude),
      double.parse(order.restaurant.longitude),
    );

    _customerCoordinates = LatLng(
      order.address.location.lat,
      order.address.location.lng,
    );

    initialcameraposition = _restaurantCoordinates;

    setMarkers(
        source: _restaurantCoordinates, destination: _customerCoordinates);

    updateMarkerAndRoute();

    super.onInit();
  }

  @override
  void onClose() {
    print('$CLASS_NAME, onClose');
    _locationTimer?.cancel();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    print('$CLASS_NAME, onMapCreated');
    _completer.complete(controller);
  }

  void setMarkers({LatLng source, LatLng destination}) {
    print('$CLASS_NAME, setMarkers');
    markers.add(Marker(
      markerId: MarkerId(source.toString()),
      position: source,
      infoWindow: InfoWindow(
        title: 'Restaurant',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));

    markers.add(Marker(
      markerId: MarkerId(destination.toString()),
      position: destination,
      infoWindow: InfoWindow(
        title: 'Customer',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    // update();
  }

  void setPolylines({LatLng source, LatLng destination}) {
    print('$CLASS_NAME, setPolylines');
    _appRepository
        .getRouteCoordinates(source: source, destination: destination)
        .then((points) {
      if (points.isNotEmpty) {
        polylines.add(Polyline(
          polylineId: PolylineId(destination.toString()),
          visible: true,
          width: 5,
          geodesic: true,
          points: points,
          color: Colors.red,
        ));
      }
      update();
    });
  }

  void goToCurrentLocation() {
    print('$CLASS_NAME, goToCurrentLocation');
    _appRepository.getCurrentPosition().then((currentLocation) {
      var currentLocationCoordinates = LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      );
      _completer.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocationCoordinates, zoom: 18)));
      });
    });
  }

// bug on location plugin
// https://github.com/Lyokone/flutterlocation/issues/422
  void updateMarkerAndRoute() async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)),
        Config.PNG_PATH + 'driver_marker.png');

    print('$CLASS_NAME, updateMyLocationMarker');
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _appRepository.getCurrentPosition().then((currentLocation) {
        if (!isCameraMoving) {
          //move camera to rider coordinates
          _completer.future.then((controller) {
            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                        currentLocation.latitude, currentLocation.longitude),
                    tilt: 80.0,
                    zoom: 21.0)));
          });
        }

        //Experimental
        //Waze like google map style
        // print('speed = ${currentLocation.speed}');
        // if (_locationHeading == 0.0) {
        //   _locationHeading = currentLocation.heading;
        // }
        // if (currentLocation.speed > 0.5) {
        //   _locationHeading = currentLocation.heading;
        // }

        // _completer.future.then((controller) {
        //   controller.animateCamera(CameraUpdate.newCameraPosition(
        //       CameraPosition(
        //           target: LatLng(
        //               currentLocation.latitude, currentLocation.longitude),
        //           tilt: 50.0,
        //           bearing: _locationHeading,
        //           zoom: double.maxFinite)));
        // });
        //Experimental

        LatLng riderCoordinates =
            LatLng(currentLocation.latitude, currentLocation.longitude);

        // show rider marker
        var riderMarker = markers.firstWhere(
          (marker) => marker.markerId.value == 'rider_position',
          orElse: () => null,
        );

        if (riderMarker != null) {
          markers.removeWhere((marker) {
            return marker.markerId.value == 'rider_position';
          });
        }

        markers.add(Marker(
          markerId: MarkerId('rider_position'),
          position: riderCoordinates,
          infoWindow: InfoWindow(
            title: 'You',
          ),
          icon: icon,
        ));

        // show polylines
        setPolylines(
          source: riderCoordinates,
          destination: order.status == 'rider-accepted'
              ? _restaurantCoordinates
              : _customerCoordinates,
        );

        update();
      });
    });
  }

  // testing change of rider location on camera move
  // void onCameraMove(CameraPosition position) async {
  //   print(position.zoom);

  //   final icon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(size: Size(48, 48)),
  //       Config.PNG_PATH + 'driver_marker.png');

  //   var riderMarker = markers.firstWhere(
  //     (marker) => marker.markerId.value == 'rider_position',
  //     orElse: () => null,
  //   );

  //   if (riderMarker != null) {
  //     markers.removeWhere((marker) {
  //       return marker.markerId.value == 'rider_position';
  //     });
  //   }
  //   markers.add(Marker(
  //     markerId: MarkerId('rider_position'),
  //     position: LatLng(position.target.latitude, position.target.longitude),
  //     infoWindow: InfoWindow(
  //       title: 'You',
  //     ),
  //     icon: icon,
  //   ));

  //   setPolylines(
  //     source: LatLng(position.target.latitude, position.target.longitude),
  //     destination: order.status == 'rider-accepted'
  //         ? _restaurantCoordinates
  //         : _customerCoordinates,
  //   );
  //   update();
  // }
}
