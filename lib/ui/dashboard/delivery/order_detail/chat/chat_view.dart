import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/data/models/message_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letsbeenextgenrider/ui/base/view/base_view.dart';

import 'chat_controller.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Config.SVG_PATH + 'back_icon.svg',
                color: Colors.black,
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 8),
              ),
              const Text('BACK')
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: _Body(),
    );
  }
}

class _Body extends BaseView<ChatController> {
  @override
  Widget get body => Container(
        margin: const EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: 16,
          top: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4.0,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.order.value.user.name}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('${controller.order.value.user.cellphoneNumber}')
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      controller.makePhoneCall();
                    },
                    icon: SvgPicture.asset(
                      Config.SVG_PATH + 'call_icon.svg',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Obx(
                    () => controller.messages.value.isEmpty
                        ? const SizedBox.shrink()
                        : Obx(
                            () => Column(
                              children: controller.messages.value
                                  .map((message) => _buildChatItem(message))
                                  .toList(),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              margin: const EdgeInsets.only(
                right: 16,
                left: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: controller.messageTF,
                      decoration: InputDecoration(
                        hintText: 'Message to customer',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                    ),
                    onPressed: () => controller.sendMessage(),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildChatItem(MessageData messageData) {
    return GetBuilder<ChatController>(
      builder: (_) {
        return _.riderId.value != messageData.userId
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_.order.value.user.name}:',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 5)),
                    Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(Config.LETSBEE_COLOR).withOpacity(1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${messageData.message}",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                          ),
                          const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                DateFormat('MMMM dd, yyyy h:mm a').format(
                                    messageData.createdAt.toUtc().toLocal()),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Me:',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${messageData.message}",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                          ),
                          const Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: messageData.isSent
                                ? Text(
                                    DateFormat('MMMM dd, yyyy h:mm a').format(
                                        messageData.createdAt
                                            .toUtc()
                                            .toLocal()),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic),
                                  )
                                : const Text('Sending...'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
