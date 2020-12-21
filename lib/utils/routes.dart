import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:letsbeenextgenrider/bindings/dashboard_binding.dart';
import 'package:letsbeenextgenrider/bindings/login_binding.dart';
import 'package:letsbeenextgenrider/bindings/order_detail_binding.dart';
import 'package:letsbeenextgenrider/bindings/splash_binding.dart';
import 'package:letsbeenextgenrider/ui/dashboard/dashboard_view.dart';
import 'package:letsbeenextgenrider/ui/dashboard/subviews/pending_detail/order_detail_view.dart';
import 'package:letsbeenextgenrider/ui/login/login_view.dart';
import 'package:letsbeenextgenrider/ui/splash/splash_view.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

routes() => [
      GetPage(
          name: Config.SPLASH_ROUTE,
          page: () => SplashView(),
          binding: SplashBinding()),
      GetPage(
          name: Config.LOGIN_ROUTE,
          page: () => LoginView(),
          binding: LoginBinding()),
      GetPage(
          name: Config.DASHBOARD_ROUTE,
          page: () => DashboardView(),
          binding: DashboardBinding()),
      GetPage(
          name: Config.ORDER_DETAIL_ROUTE,
          page: () => OrderDetailView(),
          binding: OrderDetailBinding()),
    ];
