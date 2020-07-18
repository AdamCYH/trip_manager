import 'dart:convert';

import 'package:mobile/models/models.dart';

import 'http_client.dart';

typedef RequestCallBack<T> = void Function(T value);

class API {
  static const DEFAULT_JSON_CONTENT_TYPE = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const BASE_URL = 'http://mytriphub.net/api';

  static const LOG_IN = '/token-auth/';

  var _httpClient = MyHttpClient(BASE_URL);

  void login(
      String username, String password, RequestCallBack requestCallBack) async {
    final response = await _httpClient.post(
        LOG_IN, jsonEncode({'username': username, 'password': password}),
        headers: DEFAULT_JSON_CONTENT_TYPE);
    requestCallBack(User.fromJson(response));
  }

  void authenticate(String token) {}
}
