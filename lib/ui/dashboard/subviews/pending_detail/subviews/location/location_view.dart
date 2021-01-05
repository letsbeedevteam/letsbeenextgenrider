import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/subviews/location/location_controller.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class LocationView extends GetView<LocationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Image.asset(Config.PNG_PATH + 'chat_button.png'),
              onPressed: () => Get.toNamed(Config.CHAT_ROUTE,
                  arguments: controller.order.toJson())),
        ],
        leading: IconButton(
            icon: Image.asset(Config.PNG_PATH + 'back_button.png'),
            onPressed: () => Get.back()),
      ),
      body: Stack(
        children: [
          GetBuilder<LocationController>(
            builder: (_) {
              return GoogleMap(
                markers: controller.markers,
                polylines: controller.polylines,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: controller.initialcameraposition, zoom: 18),
                onMapCreated: (GoogleMapController controller) {
                  this.controller.onMapCreated(controller);
                },
              );
            },
          ),
          Column(
            children: [
              SizedBox.fromSize(
                size: Size(0, AppBar().preferredSize.height),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: () => controller.goToCurrentLocation()),
              ),
            ],
          ),
          //  Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SizedBox(
          //     height: 100,
          //     width: 200,
          //     child: Container(
          //       color: Colors.red,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
