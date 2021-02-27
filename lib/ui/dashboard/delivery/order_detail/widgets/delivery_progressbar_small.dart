import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

import '../order_detail_controller.dart';

class DeliveryStatusProgressBarSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
      builder: (_) {
        final isMart = _.order.value.store.type == 'mart';
        final length = isMart ? 3 : 2;
        return Container(
            color: Colors.grey.shade400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i <= length; i++)
                  Obx(
                    () => _buildProgress(
                      i,
                      _.currentOrderStatus.value,
                    ),
                  ),
              ],
            ));
      },
    );
  }

  Widget _buildProgress(
    int assignedStatus,
    int currentStatus,
  ) {
    RxBool isCurrent = false.obs;
    RxBool isDone = false.obs;
    if (assignedStatus < currentStatus) {
      isDone.value = true;
      isCurrent.value = true;
    } else if (assignedStatus == currentStatus) {
      isDone.value = false;
      isCurrent.value = true;
    } else if (assignedStatus > currentStatus) {
      isDone.value = false;
      isCurrent.value = false;
    }
    return Expanded(
      child: Container(
        color: isDone.value ? Colors.green : Colors.transparent,
        child: SvgPicture.asset(
          Config.SVG_PATH + 'delivery_progress.svg',
          color: isCurrent.value ? Colors.green : Colors.grey.shade400,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
