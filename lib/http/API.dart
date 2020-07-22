import 'dart:convert';

import 'package:mobile/models/models.dart';

import 'http_client.dart';

typedef RequestCallBack<T> = void Function(T value);

class API {
  static const DEFAULT_JSON_CONTENT_TYPE = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const BASE_URL = 'http://mytriphub.net';

  static const LOG_IN = '/token-auth/';

  var _httpClient = MyHttpClient('$BASE_URL/api');

  void login(
      String username, String password, RequestCallBack requestCallBack) async {
    final response = await _httpClient.post(
        LOG_IN, jsonEncode({'username': username, 'password': password}),
        headers: DEFAULT_JSON_CONTENT_TYPE);
    requestCallBack(Auth.fromJson(response));
  }

  Future<User> getUser(
      String accessToken, String refreshToken, String userId) async {
    final response = await _httpClient.get('/user/$userId',
        headers: getAuthenticationHeader(accessToken));
    return User.fromJson(response);
  }

  Future<List<Featured>> getFeaturedItineraries() async {
    final response = await _httpClient.get('/featured/');
    return Future.value(
        response.map<Featured>((json) => Featured.fromJson(json)).toList());
  }

  Future<List<Itinerary>> getHotItineraries() async {
    final response =
        await _httpClient.get('/itinerary/?allPublic=true&sortBy=view');
    return Future.value(
        response.map<Itinerary>((json) => Itinerary.fromJson(json)).toList());
  }

  Future<Itinerary> getItineraryDetail(String id) async {
    final response = await _httpClient.get('/itinerary/$id');
    return Itinerary.fromJson(response);
  }

  Future<List<DayTrip>> getDayTrips(String id) async {
    final response = await _httpClient.get('/day-trip/?itinerary=$id');
    return Future.value(
        response.map<DayTrip>((json) => DayTrip.fromJson(json)).toList());
  }

  Map<String, String> getAuthenticationHeader(String token) {
    return {'Authorization': 'Token $token'};
  }
}
