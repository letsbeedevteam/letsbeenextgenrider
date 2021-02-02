import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/subviews/location/location_controller.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/utils/extensions.dart';

class LocationView extends GetView<LocationController> {
  @override
  Widget build(BuildContext context) {
    var _showUserInfoBottomSheet = false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          Badge(
            showBadge: false,
            position: BadgePosition.topEnd(top: 5, end: 5),
            badgeContent: Text(
              "0",
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
                icon:
                    ImageIcon(AssetImage(Config.PNG_PATH + 'chat_button.png')),
                onPressed: () => Get.toNamed(Config.CHAT_ROUTE,
                    arguments: controller.order.toJson()),
                splashColor: Colors.black.withOpacity(0.3)),
          ),
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
                onCameraIdle: () {
                  controller.isCameraMoving = false;
                },
                onCameraMove: (_) {
                  controller.isCameraMoving = true;
                },
                markers: controller.markers,
                polylines: controller.polylines,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: controller.initialcameraposition,
                  tilt: 80.0,
                  zoom: 21.0,
                ),
                // onCameraMove: (position) {
                //   controller.onCameraMove(position);
                // },
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
              Padding(padding: EdgeInsets.only(top: 12)),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: () => controller.goToCurrentLocation()),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  _showUserInfoBottomSheet = !_showUserInfoBottomSheet;
                  _showUserInfoBottomSheet
                      ? controller.controller.forward()
                      : controller.controller.reverse();
                  controller.update();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1.0)),
                  child: AnimatedSize(
                    vsync: controller,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(milliseconds: 500),
                    child: GetBuilder<LocationController>(
                      builder: (_) {
                        return Wrap(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    alignment: Alignment.center,
                                    child: _showUserInfoBottomSheet
                                        ? Icon(Icons.keyboard_arrow_down)
                                        : Icon(Icons.keyboard_arrow_up))
                              ],
                            ),
                            _showUserInfoBottomSheet
                                ? FadeTransition(
                                    opacity: controller.animation,
                                    child: _userInfoBottomSheet())
                                : Container()
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _userInfoBottomSheet() {
    return Container(
      padding: EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Column(
        children: [
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Name: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Text(
                "${controller.order.user.name}",
                style: TextStyle(fontStyle: FontStyle.italic),
              ))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Text(
                "${controller.order.address.street}, ${controller.order.address.barangay}, ${controller.order.address.city}, ${controller.order.address.state}, ${controller.order.address.country}",
                style: TextStyle(fontStyle: FontStyle.italic),
              ))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Text(
                "₱${controller.order.fee.total}",
                style: TextStyle(fontStyle: FontStyle.italic),
              ))
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Text(
                "${controller.order.payment.method.asReadablePaymentMethod()}",
                style: TextStyle(fontStyle: FontStyle.italic),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
