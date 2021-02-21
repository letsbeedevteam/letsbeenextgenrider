import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

abstract class BaseRefreshController extends GetxController {
  RxBool isLoading = false.obs;
  RxString message = ''.obs;
  Future<void> onRefresh();
}
