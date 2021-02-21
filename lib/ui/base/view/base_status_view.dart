import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseStatusView<T extends GetxController> extends GetView<T> {
  Widget get body;
  RxString get statusMessage;
  Rx<MaterialColor> get statusColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body,
        Align(
          alignment: Alignment.topCenter,
          child: Obx(
            () => AnimatedContainer(
              height: statusMessage.value.isEmpty ? 0 : 35,
              curve: Curves.decelerate,
              padding: const EdgeInsets.all(8),
              color: statusColor.value,
              duration: Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Obx(() => Text(
                          '${statusMessage.value}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
