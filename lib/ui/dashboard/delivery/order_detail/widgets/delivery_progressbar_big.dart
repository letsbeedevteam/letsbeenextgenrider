import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

import '../order_detail_controller.dart';

class DeliveryStatusProgressBarBig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
      builder: ((_) {
        final isMart = _.order.value.store.type == 'mart';
        final length = isMart ? 3 : 2;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i <= length; i++)
              Obx(
                () => _buildProgress(
                  i,
                  _.currentOrderStatus.value,
                  length,
                ),
              )
          ],
        );
      }),
    );
  }

  Widget _buildProgress(
    int assignedStatus,
    int currentStatus,
    int length,
  ) {
    ProgressBarLevel level;
    RxBool isCurrent = false.obs;
    if (assignedStatus > currentStatus) {
      isCurrent.value = false;
    } else {
      isCurrent.value = true;
    }
    Widget widget;

    if (assignedStatus == 0) {
      level = ProgressBarLevel.START;
    } else if (assignedStatus >= length) {
      level = ProgressBarLevel.END;
    } else {
      level = ProgressBarLevel.MID;
    }

    switch (level) {
      case ProgressBarLevel.START:
        widget = Expanded(
            child: isCurrent.value
                ? SvgPicture.asset(
                    Config.SVG_PATH + 'delivery_progress2_start.svg',
                    fit: BoxFit.fill,
                  )
                : SvgPicture.asset(
                    Config.SVG_PATH + 'delivery_progress2_start.svg',
                    color: Colors.grey.shade400,
                    fit: BoxFit.fill,
                  ));
        break;

      case ProgressBarLevel.MID:
        widget = Expanded(
          child: isCurrent.value
              ? SvgPicture.asset(
                  Config.SVG_PATH + 'delivery_progress2_mid.svg',
                  fit: BoxFit.fill,
                )
              : SvgPicture.asset(
                  Config.SVG_PATH + 'delivery_progress2_grey_mid.svg',
                  color: Colors.grey.shade400,
                  fit: BoxFit.fill,
                ),
        );
        break;
      case ProgressBarLevel.END:
        widget = Expanded(
          child: isCurrent.value
              ? SvgPicture.asset(
                  Config.SVG_PATH + 'delivery_progress2_end.svg',
                  fit: BoxFit.fill,
                )
              : SvgPicture.asset(
                  Config.SVG_PATH + 'delivery_progress2_grey_end.svg',
                  fit: BoxFit.fill,
                  color: Colors.grey.shade400,
                ),
        );
        break;
    }
    return widget;
  }
}

enum ProgressBarLevel {
  START,
  MID,
  END,
}
