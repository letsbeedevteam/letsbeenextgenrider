import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/core/utils/utils.dart';
import 'package:letsbeenextgenrider/ui/widget/decline_button.dart';

import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ImageIcon(
                              AssetImage(Config.PNG_PATH + 'logout_button.png'),
                              size: 40,
                            ),
                            const Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.user.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rider',
                                        style: TextStyle(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        Text(controller.user.email),
                        Text('Motorcycle: Honda, TMX 155, Black'),
                        Text('Plate No.: 1309 LN'),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deliveries',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.totalDeliveriesToday.value,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                ),
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.totalDeliveriesThisMonth.value,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                ),
                                Text(
                                  'Feb 2021',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.totalDeliveriesAlltime.value,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                ),
                                Text(
                                  'All-time',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          DeclineButton(
            onTap: () {
              showAlertDialog(
                'You\'re about to logout',
                'Are you sure you want to logout?',
                onConfirm: () {
                  controller.logOut();
                },
              );
            },
            title: 'LOGOUT',
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }
}
