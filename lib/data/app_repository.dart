import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsbeenextgenrider/core/error/exceptions.dart';
import 'package:letsbeenextgenrider/core/error/failures.dart';
import 'package:letsbeenextgenrider/core/utils/google_map_utils.dart';
import 'package:letsbeenextgenrider/core/utils/network_info.dart';
import 'package:letsbeenextgenrider/data/models/login_data.dart';
import 'package:letsbeenextgenrider/data/models/request/accept_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/get_history_by_date_and_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/get_stats_by_date_request.dart';
import 'package:letsbeenextgenrider/data/models/request/pick_up_order_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_active_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_status_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/services/google_map_service.dart';
import 'package:letsbeenextgenrider/services/location_service.dart';
import 'package:letsbeenextgenrider/services/push_notification_service.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/request/fetch_all_messages_request.dart';
import 'models/request/get_nearby_orders_request.dart';
import 'models/request/login_request.dart';
import 'models/request/refresh_token_request.dart';
import 'models/request/send_location_request.dart';
import 'models/request/send_message_request.dart';
import 'models/request/send_order_location_request.dart';
import 'models/response/get_messages_response.dart';
import 'models/response/get_nearby_orders.dart';
import 'models/response/get_new_message_response.dart';
import 'models/response/get_stats_by_date_response.dart';
import 'models/response/refresh_token_response.dart';
import 'models/response/update_order_status_response.dart';
import 'souce/local/sharedpref.dart';
import 'souce/remote/api_service.dart';
import 'souce/remote/socket_service.dart';

class AppRepository {
  final ApiService apiService;
  final SocketService socketService;
  final SharedPref sharedPref;
  final LocationService locationService;
  final GoogleMapsServices googleMapsServices;
  final PushNotificationService pushNotificationService;
  final NetworkInfo networkInfo;

  AppRepository({
    @required this.apiService,
    @required this.socketService,
    @required this.sharedPref,
    @required this.locationService,
    @required this.googleMapsServices,
    @required this.pushNotificationService,
    @required this.networkInfo,
  });

// SharedPref
  int getRiderId() => sharedPref.getRiderId();

  LoginData getUser() => LoginData(
        id: sharedPref.getRiderId(),
        name: sharedPref.getRiderName(),
        email: sharedPref.getRiderEmail(),
        role: sharedPref.getRole(),
        cellphoneNumber: sharedPref.getRiderCellphoneNumber(),
        accessToken: sharedPref.getRiderAccessToken(),
      );

// ApiService
  Future login(LoginRequest loginRequest) {
    return apiService.login(loginRequest).then((response) {
      if (response.status == 200) {
        sharedPref.saveRiderInfo(
            id: response.data.id,
            name: response.data.name,
            email: response.data.email,
            cellphoneNumber: response.data.cellphoneNumber,
            accessToken: response.data.accessToken,
            role: response.data.role);
      }
    });
  }

  Future<GetActiveOrderResponse> getCurrentOrder() async {
    if (await networkInfo.isConnected) {
      try {
        return await apiService.getCurrentOrder();
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          getCurrentOrder();
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<GetNearbyOrdersResponse> getNearbyOrders(
    double lat,
    double lng,
  ) async {
    final GetNearbyOrdersRequests request = GetNearbyOrdersRequests(
      lat: lat,
      lng: lng,
    );

    if (await networkInfo.isConnected) {
      try {
        return await apiService.getNearbyOrders(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          getNearbyOrders(lat, lng);
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<GetStatsByDateResponse> getStatsByDate({
    @required DateTime from,
    @required DateTime to,
  }) async {
    final GetStatsbyDateRequest request = GetStatsbyDateRequest(
      from: from,
      to: to,
    );

    if (await networkInfo.isConnected) {
      try {
        return await apiService.getStatsByDate(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          getStatsByDate(from: from, to: to);
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<GetHistoryByDateAndStatusResponse> getHistoryByDate({
    @required DateTime from,
    @required DateTime to,
  }) async {
    final GetHistoryByDateAndStatusRequest request = GetHistoryByDateAndStatusRequest(
      from: from,
      to: to,
      status: 'delivered',
    );

    if (await networkInfo.isConnected) {
      try {
        return await apiService.getHistoryByDate(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          getStatsByDate(from: from, to: to);
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<RefreshTokenResponse> refreshAccessToken() async {
    RefreshTokenrequest request =
        RefreshTokenrequest(sharedPref.getRiderAccessToken());

    if (await networkInfo.isConnected) {
      try {
        return await apiService.refreshAccessToken(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<UpdateOrderStatusResponse> acceptOrder(int orderId) async {
    AcceptOrderRequest request =
        AcceptOrderRequest(orderId: orderId, choice: 'accept');

    if (await networkInfo.isConnected) {
      try {
        return await apiService.acceptOrder(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          acceptOrder(orderId);
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<UpdateOrderStatusResponse> pickupOrder(int orderId) async {
    PickUpOrderRequest request = PickUpOrderRequest(orderId: orderId);

    if (await networkInfo.isConnected) {
      try {
        return await apiService.pickupOrder(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          pickupOrder(orderId);
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

  Future<UpdateOrderStatusResponse> deliverOrder(
    int orderId,
    List<LocationsRequestData> locations,
  ) async {
    DeliverOrderRequest request =
        DeliverOrderRequest(orderId: orderId, locations: locations);

    if (await networkInfo.isConnected) {
      try {
        return await apiService.deliverOrder(request);
      } on ServerException catch (e) {
        throw ServerFailure(e.cause);
      } on SocketException catch (_) {
        throw ServerFailure('Something went wrong');
      } on UnauthorizedException catch (_) {
        return refreshAccessToken().then((response) {
          sharedPref.saveRiderAccessToken(response.data.accessToken);
          deliverOrder(orderId, locations);
        }).catchError((error) {
          throw error;
        });
      }
    } else {
      throw ConnectionFailure('You don\'t have internet access');
    }
  }

// SocketService
  Future<IO.Socket> connectSocket() async {
    return socketService.connectSocket();
  }

  Future<void> disconnectSocket() async {
    socketService.socket?.close();
  }

  void receiveNewOrder(Function(dynamic) onComplete) {
    socketService.socket.on(SocketService.RECEIVE_NEW_ORDER, (response) {
      print(response);
      onComplete(response);
    });
  }

  void getCurrentActiveOrder(Function(dynamic) onComplete) {
    socketService.socket.emitWithAck(SocketService.GET_CURRENT_ACTIVE_ORDER, '',
        ack: (response) {
      print(response);
      onComplete(response);
    });
  }

  // // SocketService - Messages
  void fetchAllMessages(
    int orderId,
    Function(GetMessagesResponse) onSuccess,
    Function(String) onFailed,
  ) {
    final request = FetchAllMessagesRequest(orderId: orderId);

    socketService.socket.emitWithAck(
        SocketService.FETCH_ALL_MESSAGES, request.toJson(), ack: (response) {
      print(response);
      final getMessagesResponse = GetMessagesResponse.fromJson(response);
      if (getMessagesResponse.status == 200) {
        onSuccess(getMessagesResponse);
      } else {
        print("Failed to fetch all messages");
        onFailed("Failed to fetch all messages");
      }
    });
  }

  void sendMessage(
    int orderId,
    int customerUserId,
    String message, {
    Function(GetNewMessageResponse) onComplete,
  }) {
    print('sending message');
    var request = SendMessageRequest(
        orderId: orderId, customerUserId: customerUserId, message: message);

    socketService.socket.emitWithAck(
        SocketService.SEND_MESSAGE, request.toJson(), ack: (response) {
      print(response);
      final getNewMessageResponse = GetNewMessageResponse.fromJson(response);
      onComplete(getNewMessageResponse);
    });
  }

  void receiveNewMessages(Function(GetNewMessageResponse) onComplete) {
    socketService.socket.on(SocketService.RECEIVE_NEW_MESSAGES, (response) {
      print(response);
      final getNewMessageResponse = GetNewMessageResponse.fromJson(response);
      onComplete(getNewMessageResponse);
    });
  }

  // Locations
  void sendMyLocation() {
    print("sending my location");
    getCurrentPosition().then((currentLocation) {
      if (currentLocation != null) {
        final request = SendLocationRequest(
            location: LocationRequestData(
          lat: currentLocation.latitude,
          lng: currentLocation.longitude,
        ));
        print(request.toJson());
        socketService.socket
            .emit(SocketService.SEND_LOCATION, request.toJson());
      }
    });
  }

  void sendMyOrderLocation(int userId, int orderId) {
    print("sending my order location");
    getCurrentPosition().then((currentLocation) {
      if (currentLocation != null) {
        final request = SendOrderLocationRequest(
            location: OrderLocationRequestData(
                lat: currentLocation.latitude, lng: currentLocation.longitude),
            userId: userId,
            orderId: orderId);
        socketService.socket
            .emit(SocketService.SEND_ORDER_LOCATION, request.toJson());
      }
    });
  }

// Location
  Future<LocationData> getCurrentPosition() async =>
      await locationService.getCurrentLocation();

// GoogleMapsServices
  Future<List<LatLng>> getRouteCoordinates(
      {LatLng source, LatLng destination}) async {
    return await googleMapsServices
        .getRouteCoordinates(source, destination)
        .then((encodedPoly) {
      print(encodedPoly);
      List<LatLng> points = List<LatLng>();
      if (!encodedPoly.isBlank) {
        points = convertToLatLng(decodePoly(encodedPoly));
      }
      return points;
    });
  }

  Future<void> showNotification({String title, String body, String payload}) {
    return pushNotificationService.showNotification(
        title: title, body: body, payload: payload);
  }

  Future<void> logOut() async {
    await disconnectSocket();
    sharedPref.clearUserInfo();
  }
}
