import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';

class LocationController extends GetxController
    with SingleGetTickerProviderMixin {
  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;
  final bottomSheetKey = GlobalKey();
  final userInfoBottomSheetKey = GlobalKey();

  AnimationController controller;
  Animation<double> animation;

  OrderData order;

  LatLng initialcameraposition = LatLng(15.162884, 120.5566405);
  Completer<GoogleMapController> completer = Completer();
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  List<LatLng> routeCoordinates = List();

  Timer locationTimer;

  @override
  void onInit() {
    super.onInit();
    order = OrderData.fromJson(_argument);

    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInBack);

    createRoute();
    updateMyLocationMarker();
  }

  void onMapCreated(GoogleMapController controller) {
    completer.complete(controller);
  }

  void createRoute() {
    final restaurantCoordinates = LatLng(
      double.parse(order.restaurant.latitude),
      double.parse(order.restaurant.longitude),
    );

    final customerCoordinates = LatLng(
      order.address.location.lat,
      order.address.location.lng,
    );

    routeCoordinates.add(restaurantCoordinates);
    routeCoordinates.add(customerCoordinates);

    initialcameraposition = restaurantCoordinates;
    setMarkers(source: restaurantCoordinates, destination: customerCoordinates);
    setPolylines(
        source: restaurantCoordinates, destination: customerCoordinates);
  }

  void setMarkers({LatLng source, LatLng destination}) {
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
    update();
  }

  void setPolylines({LatLng source, LatLng destination}) {
    _appRepository
        .getRouteCoordinates(source: source, destination: destination)
        .then((points) {
      polylines.add(Polyline(
        polylineId: PolylineId(initialcameraposition.toString()),
        visible: true,
        width: 5,
        geodesic: true,
        points: points,
        color: Colors.red,
      ));
      update();
    });
  }

  void goToCurrentLocation() {
    _appRepository.getCurrentPosition().then((currentLocation) {
      var currentLocationCoordinates = LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      );
      completer.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: currentLocationCoordinates, zoom: 18)));
      });
    });
  }

// bug on location plugin
// https://github.com/Lyokone/flutterlocation/issues/422
  void updateMyLocationMarker() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      _appRepository.getCurrentPosition().then((currentLocation) {
        LatLng currentPositionCoordinates =
            LatLng(currentLocation.latitude, currentLocation.longitude);

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
          position: currentPositionCoordinates,
          infoWindow: InfoWindow(
            title: 'You',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
        update();
      });
    });
  }
}
