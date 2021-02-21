import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

class AcceptButton extends StatelessWidget {
  AcceptButton({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.mainAxisSize,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final RxBool isAcceptButtonPressed = false.obs;
    return GestureDetector(
      onTapDown: (_) {
        isAcceptButtonPressed.value = true;
      },
      onTapUp: (_) {
        isAcceptButtonPressed.value = false;
        onTap();
      },
      onTapCancel: () {
        isAcceptButtonPressed.value = false;
      },
      onPanDown: (_) {
        isAcceptButtonPressed.value = true;
      },
      onPanEnd: (_) {
        isAcceptButtonPressed.value = false;
      },
      onPanCancel: () {
        isAcceptButtonPressed.value = false;
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
              color: isAcceptButtonPressed.value
                  ? Colors.amber
                  : Color(Config.LETSBEE_COLOR).withOpacity(1),
              border: Border.fromBorderSide(
                BorderSide(color: Color(Config.LETSBEE_COLOR).withOpacity(1)),
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
