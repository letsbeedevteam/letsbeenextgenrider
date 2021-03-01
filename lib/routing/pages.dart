import 'package:get/get.dart';
import 'package:letsbeenextgenrider/bindings/chat_binding.dart';
import 'package:letsbeenextgenrider/bindings/dashboard_binding.dart';
import 'package:letsbeenextgenrider/bindings/login_binding.dart';
import 'package:letsbeenextgenrider/bindings/order_detail_binding.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/chat/chat_view.dart';
import 'package:letsbeenextgenrider/ui/splash/splash_binding.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/delivery/order_detail/order_detail_view.dart';
import 'package:letsbeenextgenrider/ui/login/login_view.dart';
import 'package:letsbeenextgenrider/ui/splash/splash_view.dart';

part 'routes.dart';

class Pages{
  static final pages = [
      GetPage(
          name: Routes.SPLASH_ROUTE,
          page: () => SplashView(),
          binding: SplashBinding()),
      GetPage(
          name: Routes.LOGIN_ROUTE,
          page: () => LoginView(),
          binding: LoginBinding()),
      GetPage(
          name: Routes.DASHBOARD_ROUTE,
          page: () => DashboardView(),
          binding: DashboardBinding()),
      GetPage(
          name: Routes.ORDER_DETAIL_ROUTE,
          page: () => OrderDetailView(),
          binding: OrderDetailBinding()),
      GetPage(
          name: Routes.CHAT_ROUTE,
          page: () => ChatView(),
          binding: ChatBinding()),
    ];
}