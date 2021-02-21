import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';

import 'config.dart';

Widget dismissKeyboard(BuildContext context, {child: Widget}) {
  return GestureDetector(
    onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }
    },
    child: child,
  );
}

void showAlertDialog(String message, {Function() onConfirm}) {
  Get.dialog(AlertDialog(
      backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Get.back();
                  }),
              RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    onConfirm();
                    Get.back();
                  })
            ],
          ),
        ],
      )));
}

void showSnackbar(String title, String message) {
  Get.snackbar(title, message,
      duration: Duration(seconds: 5),
      backgroundColor: Color(Config.LETSBEE_COLOR).withOpacity(1.0),
      isDismissible: true,
      icon: Icon(
        Icons.error,
        color: Colors.redAccent,
      ));
}

bool isNewOrder(dynamic response) {
  try {
    OrderData.fromJson(response);
    return true;
  } catch (e) {
    print('isNewOrder = $e');
    return false;
  }
}

bool isUpdatedOrder(dynamic response) {
  try {
    GetNewOrderResponse.fromJson(response);
    return true;
  } catch (e) {
    return false;
  }
}

bool isOrderData(dynamic response) {
  try {
    orderDataFromJson(response);
    return true;
  } catch (e) {
    return false;
  }
}
