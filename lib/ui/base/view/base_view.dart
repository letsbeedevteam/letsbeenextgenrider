import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';

//base view with refresh and custom snackbar
abstract class BaseView<T extends BaseController> extends GetView<T> {
  Widget get body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            controller.onRefresh();
          },
          child: body,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Obx(
            () => AnimatedContainer(
              height: controller.isShownSnackbar.value ? 35 : 0,
              curve: Curves.decelerate,
              padding: const EdgeInsets.all(8),
              color: controller.snackbarBackgroundColor.value,
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Obx(
                      () => Text(
                        '${controller.snackBarMessage.value.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => controller.message.value.isBlank || controller.isLoading.value
              ? const SizedBox.shrink()
              : Center(
                  child: Text(controller.message.value),
                ),
        ),
        Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: const CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
