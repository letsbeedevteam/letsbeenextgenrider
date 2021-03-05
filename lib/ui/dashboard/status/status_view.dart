import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';

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
                          DateFormat('dd MMM yyyy')
                              .format(controller.dateToday),
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
                            Obx(
                              () => Text(
                                controller.workStatus.value,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: 60,
                      child: SvgPicture.asset(
                        Config.SVG_PATH + controller.workStatusIconPath.value,
                        color: Colors.black,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return GestureDetector(
      onTap: () {
        showAlertDialog(
          controller.isSwitchOn.value
              ? 'Time out'
              : 'Time in',
          controller.isSwitchOn.value
              ? 'Are you sure you want to sign out to end your shift?'
              : 'Are you sure you want to sign in to start your shift?',
          onConfirm: () {
            controller.updateWorkStatus(controller.isSwitchOn.value);
          },
        );
      },
      child: Obx(
        () => AnimatedContainer(
          width: 50,
          height: 25,
          child: AnimatedAlign(
            alignment: controller.isSwitchOn.value
                ? Alignment.centerRight
                : Alignment.centerLeft,
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
            color: controller.isSwitchOn.value
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
