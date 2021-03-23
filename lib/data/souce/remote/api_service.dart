import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:letsbeenextgenrider/core/error/exceptions.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';
import 'package:letsbeenextgenrider/data/models/request/accept_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/deliver_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/get_history_by_date_and_status_request.dart';
import 'package:letsbeenextgenrider/data/models/request/get_nearby_orders_request.dart';
import 'package:letsbeenextgenrider/data/models/request/get_stats_by_date_request.dart';
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
import 'package:letsbeenextgenrider/data/models/request/pick_up_order_request.dart';
import 'package:letsbeenextgenrider/data/models/request/refresh_token_request.dart';
import 'package:letsbeenextgenrider/data/models/request/send_current_order_location_request.dart';
import 'package:letsbeenextgenrider/data/models/request/update_work_status_request.dart';
import 'package:letsbeenextgenrider/data/models/response/get_active_order_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_nearby_orders.dart';
import 'package:letsbeenextgenrider/data/models/response/get_stats_by_date_response.dart';
import 'package:letsbeenextgenrider/data/models/response/get_history_by_date_and_status_response.dart';
import 'package:letsbeenextgenrider/data/models/response/login_response.dart';
import 'package:letsbeenextgenrider/data/models/response/refresh_token_response.dart';
import 'package:letsbeenextgenrider/data/models/response/update_order_status_response.dart';
import 'package:letsbeenextgenrider/data/souce/local/sharedpref.dart';

class ApiService extends GetxController {
  final GetStorage getStorage;

  ApiService({@required this.getStorage});

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await http.post(Config.BASE_URL + Config.SIGN_IN,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginRequest.toJson()));

    print('login: ${response.body}');

    return loginResponseFromJson(response.body);
  }

  Future<GetNearbyOrdersResponse> getNearbyOrders(
    GetNearbyOrdersRequests request,
  ) async {
    final response = await http.get(
      Config.getNearbyOrders(request.lat, request.lng),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
      },
    );

    print('getNearbyOrders: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return getNearbyOrdersResponseFromJson(response.body);
        break;
      case 'NOT_FOUND':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<GetActiveOrderResponse> getCurrentOrder() async {
    print('${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}');
    final response = await http.get(
      Config.GET_CURRENT_ORDER,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
      },
    );

    print('getCurrentOrder: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return getActiveOrderResponseFromJson(response.body);
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<UpdateOrderStatusResponse> acceptOrder(
    AcceptOrderRequest request,
  ) async {
    final response = await http.post(Config.ACCEPT_ORDER,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
        },
        body: jsonEncode(request.toJson()));

    print('acceptOrder: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return updateOrderStatusResponseFromJson(response.body);
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<UpdateOrderStatusResponse> pickupOrder(
    PickUpOrderRequest request,
  ) async {
    final response = await http.post(Config.PICKUP_ORDER,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
        },
        body: jsonEncode(request.toJson()));

    print('pickupOrder: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return updateOrderStatusResponseFromJson(response.body);
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<UpdateOrderStatusResponse> deliverOrder(
      DeliverOrderRequest request) async {
    final response = await http.post(Config.DELIVER_ORDER,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
        },
        body: jsonEncode(request.toJson()));

    print('deliverOrder: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return updateOrderStatusResponseFromJson(response.body);
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<RefreshTokenResponse> refreshAccessToken(
      RefreshTokenrequest request) async {
    final response = await http.post(Config.REFRESH_ACCESS_TOKEN,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()));

    print('RefreshToken: ${response.body}');
    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return refreshTokenResponseFromJson(response.body);
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<GetStatsByDateResponse> getStatsByDate(
    GetStatsbyDateRequest request,
  ) async {
    final response = await http.get(
      Config.getStatsByDate(
          from: request.from.toIso8601String(),
          to: request.to.toIso8601String()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
      },
    );

    print('getStatsByDate: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return getStatsByDateResponseFromJson(response.body);
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<GetHistoryByDateAndStatusResponse> getHistoryByDate(
    GetHistoryByDateAndStatusRequest request,
  ) async {
    final response = await http.get(
      Config.getHistoryByDateAndStatus(
          from: request.from.toIso8601String(),
          to: request.to.toIso8601String(),
          page: request.page),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
      },
    );

    print(
        'getHistoryByDateAndStatus:\nrequest = ${jsonEncode(request.toJson())}\nresponse = ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return getHistoryByDateAndStatusResponseFromJson(response.body);
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<bool> updateWorkStatus(
    UpdateWorkStatusRequest request,
  ) async {
    final response = await http.post(Config.UPDATE_WORK_STATUS,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
        },
        body: jsonEncode(request.toJson()));

    print('updateWorkStatus: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return true;
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }

  Future<bool> sendCurrentOrderLocation(
    SendCurrentOrderLocationRequest request,
  ) async {
    final response = await http.post(Config.SEND_CURRENT_LOCATION_ORDER,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${getStorage.read(SharedPref.RIDER_ACCESS_TOKEN)}',
        },
        body: jsonEncode(request.toJson()));

    print('sendOrderLocation: ${response.body}');

    String status = json.decode(response.body)['status'];
    String message = json.decode(response.body)['error_message'];

    switch (status) {
      case 'OK':
        return true;
        break;
      case 'EXPIRED':
        throw UnauthorizedException('Token Expired');
        break;
      default:
        throw ServerException(message);
        break;
    }
  }
}
