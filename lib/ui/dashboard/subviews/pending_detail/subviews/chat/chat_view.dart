import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/models/message_data.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/subviews/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:intl/intl.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset(Config.PNG_PATH + 'back_button.png'),
              onPressed: () => Get.back()),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${controller.order.value.user.name}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  'Address: ${controller.order.value.address.street}, ${controller.order.value.address.barangay}, ${controller.order.value.address.city}, ${controller.order.value.address.state}, ${controller.order.value.address.country}}',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
              Text(
                  '${controller.order.value.store.name} - ${controller.order.value.store.locationName}',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
            ],
          ),
          centerTitle: false,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: Scrollbar(
              child: SingleChildScrollView(
                reverse: true,
                child: GetX<ChatController>(builder: (_) {
                  return _.messages.value.isEmpty
                      ? Container()
                      : Column(
                          children: _.messages.value
                              .map((message) => _buildChatItem(message))
                              .toList(),
                        );
                }),
              ),
            )),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2.0,
                        offset: Offset(3.0, 3.0))
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: controller.messageTF,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => controller.sendMessage())
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        ));
  }
}

Widget _buildChatItem(MessageData messageData) {
  return GetX<ChatController>(
    builder: (_) {
      return _.riderId.value != messageData.userId
          ? Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_.order.value.user.name}:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Container(
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.yellow.shade200,
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              offset: Offset(3.0, 3.0))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${messageData.message}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              DateFormat('MMMM dd, yyyy h:mm a').format(
                                  messageData.createdAt.toUtc().toLocal()),
                              style: TextStyle(
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
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Me:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Container(
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2.0,
                              offset: Offset(3.0, 3.0))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${messageData.message}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left,
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: messageData.isSent
                              ? Text(
                                  DateFormat('MMMM dd, yyyy h:mm a').format(
                                      messageData.createdAt.toUtc().toLocal()),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic))
                              : Text('Sending...'),
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
