import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:letsbeenextgenrider/core/utils/network_info.dart';
import 'package:letsbeenextgenrider/ui/splash/splash_binding.dart';
import 'package:letsbeenextgenrider/data/app_repository.dart';
import 'package:letsbeenextgenrider/data/souce/local/sharedpref.dart';
import 'package:letsbeenextgenrider/data/souce/remote/api_service.dart';
import 'package:letsbeenextgenrider/data/souce/remote/socket_service.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import 'core/utils/config.dart';
import 'core/utils/utils.dart';
import 'core/utils/extensions.dart';
import 'routing/pages.dart';
import 'services/google_map_service.dart';
import 'services/location_service.dart';
import 'services/push_notification_service.dart';

//started working at 9:42am Sunday

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}

Future initServices() async {
  print('Initializing Dependencies');
  await Get.putAsync<GetStorage>(() async => GetStorage(), permanent: true);
  await Get.putAsync<Location>(() async => Location(), permanent: true);
  await Get.putAsync<NetworkInfo>(
      () async => NetworkInfo(dataConnectionChecker: DataConnectionChecker()),
      permanent: true);
  await Get.putAsync<PushNotificationService>(
      () async => PushNotificationService(),
      permanent: true);
  await Get.putAsync<GoogleMapsServices>(() async => GoogleMapsServices(),
      permanent: true);
  await Get.putAsync<LocationService>(() async => LocationService(),
      permanent: true);
  await Get.putAsync<ApiService>(() async => ApiService(getStorage: Get.find()),
      permanent: true);
  await Get.putAsync<SocketService>(() async => SocketService(),
      permanent: true);
  await Get.putAsync<SharedPref>(() async => SharedPref(), permanent: true);
  await Get.putAsync<AppRepository>(
      () async => AppRepository(
          apiService: Get.find(),
          googleMapsServices: Get.find(),
          locationService: Get.find(),
          networkInfo: Get.find(),
          pushNotificationService: Get.find(),
          sharedPref: Get.find(),
          socketService: Get.find()),
      permanent: true);
  print('Dependencies Intialized');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return dismissKeyboard(
      context,
      child: GetMaterialApp(
        title: Config.APP_NAME,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(brightness: Brightness.light),
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: 
            Color(Config.LETSBEE_COLOR).withOpacity(1).toMaterialColor()),
        enableLog: true,
        debugShowCheckedModeBanner: false,
        getPages: Pages.pages,
        transitionDuration: const Duration(milliseconds: 500),
        defaultTransition: Transition.fade,
        initialBinding: SplashBinding(),
        initialRoute: Routes.SPLASH_ROUTE,
      ),
    );
  }
}
