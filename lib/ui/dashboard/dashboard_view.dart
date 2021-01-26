import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/request/accept_order_request.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_controller.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:letsbeenextgenrider/utils/utils.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('"INCOMING DELIVERY"',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
                icon: ImageIcon(
                    AssetImage(Config.PNG_PATH + 'logout_button.png'),
                    size: 20),
                onPressed: () {
                  showAlertDialog("Are you sure you want to logout?",
                      onConfirm: () {
                    controller.logOut();
                  });
                },
                splashColor: Colors.black.withOpacity(0.3)),
          ],
        ),
        body: GetX<DashboardController>(builder: (_) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.onRefresh,
                child: Scrollbar(
                    child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: _.orders.value
                      .map((order) => _buildDeliveryItem(order))
                      .toList(),
                )),
              ),
              _.orders.value.isEmpty
                  ? Center(
                      child: Text(_.message.value),
                    )
                  : Container()
            ],
          );
        }));
  }

  Widget _buildDeliveryItem(OrderData order) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Order NO. ${order.id}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${order.user.name}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                Text(
                    'Date and Time: ' +
                        DateFormat('MMMM dd, yyyy h:mm a')
                            .format(order.updatedAt.toUtc().toLocal()),
                    style: TextStyle(fontStyle: FontStyle.italic)),
                Text('Total Amount: ₱${order.fee.total}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                Text(
                    'Estimated cooking time: ${order.timeframe.restaurantEstimatedTime}',
                    style: TextStyle(fontStyle: FontStyle.italic))
              ],
            ),
          ),
          GetX<DashboardController>(builder: (_) {
            return Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.black)),
                  color: Colors.green.withOpacity(1.0),
                  child: Text('Accept',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: _.isLoading.value
                      ? null
                      : () => {
                            controller.updateOrderStatus(
                                'order-choice',
                                AcceptOrderRequest(
                                    orderId: order.id, choice: 'accept'),
                                order),
                          }),
            );
          }),
          Divider()
        ],
      ),
    );
  }
}
