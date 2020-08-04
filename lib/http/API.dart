import 'dart:convert';

import 'package:mobile/models/auth_service.dart';
import 'package:mobile/models/exceptions.dart';
import 'package:mobile/models/models.dart';

import 'http_client.dart';

typedef RequestCallBack<T> = void Function(T value);

class API {
  static const DEFAULT_JSON_CONTENT_TYPE = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const BASE_URL = 'http://mytriphub.net';

  static const LOG_IN = '/token-auth/';
  static const REFRESH_TOKEN = '/token-auth/refresh/';

  var _httpClient = MyHttpClient('$BASE_URL/api');

  void login(
      String username, String password, RequestCallBack requestCallBack) async {
    try {
      final response = await _httpClient.post(
          LOG_IN, jsonEncode({'username': username, 'password': password}),
          headers: DEFAULT_JSON_CONTENT_TYPE);
      requestCallBack(Auth.fromJson(response));
    } on Exception catch (e) {
      print(e);
      requestCallBack(null);
    }
  }

  void refreshToken(String token, RequestCallBack requestCallBack) async {
    try {
      final response = await _httpClient.post(
          REFRESH_TOKEN, jsonEncode({'refresh': token}),
          headers: DEFAULT_JSON_CONTENT_TYPE);
      requestCallBack(response['access']);
    } on Exception catch (e) {
      print(e);
      requestCallBack(null);
    }
  }

  Future<User> getUser(String accessToken, String refreshToken, String userId,
      AuthService authService) async {
    try {
      final response = await _httpClient.get('/user/$userId',
          headers: getAuthenticationHeader(accessToken));
      authService.authStatus = AuthStatus.AUTHENTICATED;
      return User.fromJson(response);
    } on UnauthorisedException catch (e) {
      print(e);
      authService.authStatus = AuthStatus.UNAUTHENTICATED;
      return null;
    } on Exception catch (e) {
      authService.authStatus = AuthStatus.UNAUTHENTICATED;
      print(e);
      return null;
    }
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

  Future<List<Itinerary>> getMyItineraries(
      String accessToken, String owner) async {
    final response = await _httpClient.get(
        '/itinerary/?owner=$owner&sortBy=posted_on',
        headers: getAuthenticationHeader(accessToken));
    return Future.value(
        response.map<Itinerary>((json) => Itinerary.fromJson(json)).toList());
  }

  Future<Itinerary> getItineraryDetail(String id, String accessToken) async {
    final response = await _httpClient.get('/itinerary/$id',
        headers: getAuthenticationHeader(accessToken));
    return Itinerary.fromJson(response);
  }

  Future<List<DayTrip>> getDayTrips(String id) async {
    final response = await _httpClient.get('/day-trip/?itinerary=$id');
    return Future.value(
        response.map<DayTrip>((json) => DayTrip.fromJson(json)).toList());
  }

  Map<String, String> getAuthenticationHeader(String token) {
    return token == null || token.isEmpty
        ? {}
        : {'Authorization': 'Token $token'};
  }

  Future<Itinerary> createItinerary(Map<String, String> fields,
      List<String> filePaths, String accessToken) async {
    try {
      var response = await _httpClient.multipartPost('/itinerary/', fields, filePaths,
          headers: getAuthenticationHeader(accessToken));
      return Itinerary.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
