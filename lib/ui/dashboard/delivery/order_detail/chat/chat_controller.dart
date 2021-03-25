import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/models/message_data.dart';
import 'package:letsbeenextgenrider/data/models/order_data.dart';
import 'package:letsbeenextgenrider/ui/base/controller/base_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends BaseController {
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

    _initSocketMessagegs();
    _fetchAllMessages();
    _receiveNewMessages();

    super.onInit();
  }

  void _initSocketMessagegs() async {
    await _appRepository.getActiveSocket()
      ..on('connect', (_) {
        print('connected');
        showSnackbarSuccessMessage('Connected');
        _receiveNewMessages();
      })
      ..on('connecting', (_) {
        print('connecting');
        showSnackbarInfoMessage('Trying to reconnect...');
      })
      ..on('reconnecting', (_) {
        print('reconnecting');
        showSnackbarInfoMessage('Trying to reconnect...');
      })
      ..on('disconnect', (_) {
        print('disconnected');
        showSnackbarErrorMessage('Disconnected. Try refreshing');
      })
      ..on('error', (_) {
        print('socket error = $_');
      });
  }

  ///this will subscribe on [order-chat] event from server
  ///to receive new messages
  void _receiveNewMessages() {
    print('$CLASS_NAME, _receiveNewMessages');
    _appRepository.receiveNewMessages((response) async {
      messages.value.add(response.data);
    });
  }

  ///this will subscribe on [order-chats] event from server
  ///to fetch 10 most recent messages
  void _fetchAllMessages() {
    showSnackbarInfoMessage('Loading messages...');
    print('$CLASS_NAME, _fetchAllMessages');
    messages.value.clear();
    _appRepository.fetchAllMessages(order.value.id, (response) {
      messages.value.addAll(response.data);
      messages.value.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
      showSnackbarSuccessMessage('Messages updated');
    }, (error) {
      showSnackbarErrorMessage(error);
    });
  }

  void sendMessage() {
    print('$CLASS_NAME, sendMessage');
    if (!messageTF.text.isBlank || messageTF.text.isNotEmpty) {
      messages.value.add(
        MessageData(
          userId: riderId.value,
          orderId: order.value.id,
          message: messageTF.text,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          isSent: false,
        ),
      );

      _appRepository
          .sendMessage(order.value.id, order.value.userId, messageTF.text,
              onComplete: (response) {
        if (response.status == 'OK') {
          messages.value.removeWhere((message) => message.isSent == false);
          messages.value.add(response.data);
        }
      });

      messageTF.clear();
    }
  }

  void makePhoneCall() async {
    if (order.value.user.cellphoneNumber != null) {
      var uri = 'tel:${order.value.user.cellphoneNumber}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch';
      }
    }
  }

  @override
  void onRefresh() {
    print('$CLASS_NAME, onRefresh');
  }
}
