import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/data/models/response/get_new_order_response.dart';
import 'package:letsbeenextgenrider/ui/widget/accept_button.dart';
import 'package:letsbeenextgenrider/ui/widget/decline_button.dart';

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

void showAlertDialog(
  String title,
  String message, {
  String confirmButtonText = 'YES',
  String cancelButtonText = 'NO',
  Function() onConfirm,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      content: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            Text(
              message,
              textAlign: TextAlign.start,
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DeclineButton(
                      onTap: () {
                        Get.back();
                      },
                      title: cancelButtonText,
                      mainAxisSize: MainAxisSize.max),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                Expanded(
                  child: AcceptButton(
                    onTap: () {
                      onConfirm();
                      Get.back();
                    },
                    title: confirmButtonText,
                    mainAxisSize: MainAxisSize.max,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
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
