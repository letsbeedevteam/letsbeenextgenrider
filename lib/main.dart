import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/bindings/splash_binding.dart';
import 'package:letsbeenextgenrider/service/api_service.dart';
import 'package:letsbeenextgenrider/service/socket_service.dart';
import 'package:letsbeenextgenrider/utils/config.dart';
import 'package:letsbeenextgenrider/utils/routes.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}

Future initServices() async {
  print('Starting services...');
  // await Get.putAsync(() => GetStorage.init(Config.PARTNER_STORAGE));
  await Get.putAsync<GetStorage>(() async => GetStorage());
  // await Get.putAsync<PushNotificationService>(() async => PushNotificationService());
  await Get.putAsync<SocketService>(() async => SocketService());
  await Get.putAsync<ApiService>(() async => ApiService());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Config.APP_NAME,
      theme: ThemeData(
          appBarTheme: AppBarTheme(brightness: Brightness.light),
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.yellow),
      enableLog: true,
      debugShowCheckedModeBanner: false,
      getPages: routes(),
      transitionDuration: Duration(milliseconds: 500),
      defaultTransition: Transition.fade,
      initialBinding: SplashBinding(),
      initialRoute: Config.SPLASH_ROUTE,
    );
  }
}
