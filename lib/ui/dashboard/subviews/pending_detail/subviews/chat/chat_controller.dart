import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/message_data.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';

class ChatController extends GetxController {
  final AppRepository _appRepository = Get.find();

  final _argument = Get.arguments;
  final messageTF = TextEditingController();

  var riderId = 0.obs;
  var isLoading = false.obs;
  var order = OrderData().obs;
  var messages = RxList<MessageData>().obs;

  @override
  void onInit() {
    order.value = OrderData.fromJson(_argument);
    riderId.value = _appRepository.getRiderId();

    _fetchAllMessages();
    _receiveNewMessages();

    super.onInit();
  }

  void _receiveNewMessages() {
    _appRepository.receiveNewMessages((response) {
      messages.value.add(response.data);
    });
  }

  void _fetchAllMessages() {
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
    _appRepository.sendMessage(
        order.value.id, order.value.userId, messageTF.text);
    messageTF.clear();
  }
}
