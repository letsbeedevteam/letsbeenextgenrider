import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_refresh_controller.dart';

abstract class BaseRefreshView<T extends BaseRefreshController>
    extends GetView<T> {
  ///Body must contain a scrollable child
  ///for the refresh indicator to be visible
  Widget get body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: body,
                ),
                Obx(
                  () => Center(
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const SizedBox.shrink(),
                  ),
                ),
                Obx(
                  () => Center(
                    child: controller.message.value.isNotEmpty &&
                            !controller.isLoading.value
                        ? Text(controller.message.value)
                        : const SizedBox.shrink(),
                  ),
                )
              ],
            ),
            onRefresh: controller.onRefresh),
      ],
    );
  }
}
