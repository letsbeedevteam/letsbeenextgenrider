import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/message_data.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';

class ChatController extends GetxController {
  static const CLASS_NAME = 'ChatController';

  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;

  final messageTF = TextEditingController();
  RxInt riderId = 0.obs;
  RxBool isLoading = false.obs;
  Rx<OrderData> order = OrderData().obs;
  Rx<RxList<MessageData>> messages = RxList<MessageData>().obs;

  @override
  void onInit() {
    print('$CLASS_NAME, onInit');
    order.value = OrderData.fromJson(_argument);

    riderId.value = _appRepository.getRiderId();

    _fetchAllMessages();
    _receiveNewMessages();

    super.onInit();
  }

  ///Todo: need to remove [_receiveNewMessages] in chat page
  ///[OrderDetailController] already had [_receiveNewMessages]
  ///this will subscribe on [order] event from server
  ///everytime the chat page is opened
  void _receiveNewMessages() {
    print('$CLASS_NAME, _receiveNewMessages');
    _appRepository.receiveNewMessages((response) async {
      messages.value.add(response.data);
    });
  }

  void _fetchAllMessages() {
    print('$CLASS_NAME, _fetchAllMessages');
    messages.value.clear();
    _appRepository.fetchAllMessages(order.value.id, (response) {
      messages.value.addAll(response.data);
      messages.value.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
    }, (error) {
      print(error);
    });
  }

  void sendMessage() {
    print('$CLASS_NAME, sendMessage');
    messages.value.add(MessageData(
        userId: riderId.value,
        orderId: order.value.id,
        message: messageTF.text,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        isSent: false));

    _appRepository
        .sendMessage(order.value.id, order.value.userId, messageTF.text,
            onComplete: (response) {
      if (response.status == 200) {
        messages.value.removeWhere((message) => message.isSent == false);
        messages.value.add(response.data);
      }
    });

    messageTF.clear();
  }
}
