import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeclineButton extends StatelessWidget {
  DeclineButton({
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
    final RxBool isPressed = false.obs;

    return GestureDetector(
      onTapDown: (_) {
        isPressed.value = true;
      },
      onTapUp: (_) async {
         isPressed.value = false;
         onTap();
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
              color: isPressed.value
                      ? Colors.red
                      : Colors.white,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.red),
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(color: isPressed.value ? Colors.white : Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
