import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

import 'status_controller.dart';

class StatusView extends GetView<StatusController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date today',
                        ),
                        Text(
                          '24 Jun 2021',
                          style: const TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        Row(
                          children: [
                            _buildSwitch(),
                            const Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            Text(
                              'You have left work',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ImageIcon(
                    AssetImage(Config.PNG_PATH + 'logout_button.png'),
                    size: 40,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    RxBool isSwitchOn = false.obs;
    return GestureDetector(
      onTap: () {
        isSwitchOn.value = !isSwitchOn.value;
      },
      child: Obx(
        () => AnimatedContainer(
          width: 50,
          height: 25,
          child: AnimatedAlign(
            alignment:
                isSwitchOn.value ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(
              milliseconds: 100,
            ),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(),
                  )),
            ),
          ),
          decoration: BoxDecoration(
            color: isSwitchOn.value
                ? Color(Config.LETSBEE_COLOR).withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.fromBorderSide(
              BorderSide(),
            ),
          ),
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
