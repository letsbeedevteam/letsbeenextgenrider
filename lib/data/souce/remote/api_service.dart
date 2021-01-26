import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:letsbeenextgenrider/data/models/request/login_request.dart';
import 'package:letsbeenextgenrider/data/models/request/refresh_token_request.dart';
import 'package:letsbeenextgenrider/data/models/response/login_response.dart';
import 'package:letsbeenextgenrider/data/models/response/refresh_token_response.dart';
import 'package:letsbeenextgenrider/utils/config.dart';

class ApiService extends GetxController {
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await http.post(Config.BASE_URL + Config.SIGN_IN,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginRequest.toJson()));

    print('Login: ${response.body}');

    return loginResponseFromJson(response.body);
  }

  Future<RefreshTokenResponse> refreshAccessToken(RefreshTokenrequest refreshTokenrequest) async {
    final response = await http.post(Config.BASE_URL + Config.REFRESH_ACCESS_TOKEN,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(refreshTokenrequest.toJson()));

    print('RefreshToken: ${response.body}');

    return refreshTokenResponseFromJson(response.body);
  }
}
