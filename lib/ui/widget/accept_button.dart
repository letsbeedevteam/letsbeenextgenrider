import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

class AcceptButton extends StatelessWidget {
  AcceptButton({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.mainAxisSize,
    this.enabled = true,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final MainAxisSize mainAxisSize;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final RxBool isPressed = false.obs;

    return GestureDetector(
      onTapDown: (_) {
        isPressed.value = true;
      },
      onTapUp: (_) async {
        isPressed.value = false;
        if (enabled) {
          onTap();
        }
      },
      onTapCancel: () {
        isPressed.value = false;
      },
      onPanDown: (_) {
        isPressed.value = true;
      },
      onPanEnd: (_) {
        isPressed.value = false;
      },
      onPanCancel: () {
        isPressed.value = false;
      },
      child: Obx(
        () => Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
              color: !enabled
                  ? Colors.grey.shade400
                  : isPressed.value
                      ? Colors.amber
                      : Color(Config.LETSBEE_COLOR).withOpacity(1),
              border: Border.fromBorderSide(
                BorderSide(
                  color: !enabled
                      ? Colors.grey.shade400
                      : Color(Config.LETSBEE_COLOR).withOpacity(1),
                ),
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
