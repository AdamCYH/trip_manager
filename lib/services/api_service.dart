import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/exceptions.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/http_service.dart';

typedef RequestCallBack<T> = void Function(T value);

class ApiService {
  static const DEFAULT_JSON_CONTENT_TYPE = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const BASE_URL = 'http://mytriphub.net';

  static const LOG_IN = '/token-auth/';
  static const REFRESH_TOKEN = '/token-auth/refresh/';

  var _httpService;

  ApiService() {
    _httpService = HttpService('$BASE_URL/api', http.Client());
  }

  void login(
      String username, String password, RequestCallBack requestCallBack) async {
    try {
      final response = await _httpService.post(
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
      final response = await _httpService.post(
          REFRESH_TOKEN, jsonEncode({'refresh': token}),
          headers: DEFAULT_JSON_CONTENT_TYPE);
      requestCallBack(response['access']);
    } on Exception catch (e) {
      print(e);
      requestCallBack(null);
    }
  }

  Future<User> createUser(User user) async {
    final response = await _httpService
        .post('/user/', user.toJson(), headers: <String, String>{});
    return User.fromJson(response);
  }

  Future<User> getUser(String accessToken, String refreshToken, String userId,
      AuthService authService) async {
    try {
      final response = await _httpService.get('/user/$userId',
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

  Future<Map<String, Featured>> getFeaturedItineraries() async {
    final response = await _httpService.get('/featured/');
    var featuredMap = new LinkedHashMap<String, Featured>();
    response.forEach((json) {
      var featured = Featured.fromJson(json);
      featuredMap[featured.itinerary.id] = featured;
    });
    return featuredMap;
  }

  Future<Map<String, Itinerary>> getHotItineraries() async {
    final response =
        await _httpService.get('/itinerary/?allPublic=true&sortBy=view');
    var hotMap = new LinkedHashMap<String, Itinerary>();
    response.forEach((json) {
      var hot = Itinerary.fromJson(json);
      hotMap[hot.id] = hot;
    });
    return hotMap;
  }

  Future<Map<String, Itinerary>> getMyItineraries(
      String accessToken, String owner) async {
    final response = await _httpService.get(
        '/itinerary/?owner=$owner&sortBy=posted_on',
        headers: getAuthenticationHeader(accessToken));
    var itineraryMap = new LinkedHashMap<String, Itinerary>();
    response.forEach((json) {
      var itinerary = Itinerary.fromJson(json);
      itineraryMap[itinerary.id] = itinerary;
    });
    return itineraryMap;
  }

  Future<Itinerary> getItineraryDetail(String id, String accessToken) async {
    final response = await _httpService.get('/itinerary/$id',
        headers: getAuthenticationHeader(accessToken));
    return Itinerary.fromJson(response);
  }

  Future<List<DayTrip>> getDayTrips(String id) async {
    final response = await _httpService.get('/day-trip/?itinerary=$id');
    return response.map<DayTrip>((json) => DayTrip.fromJson(json)).toList();
  }

  Map<String, String> getAuthenticationHeader(String token) {
    return token == null || token.isEmpty
        ? {}
        : {'Authorization': 'Token $token'};
  }

  Future<Itinerary> createItinerary(Map<String, String> fields,
      List<String> filePaths, String accessToken) async {
    try {
      var response = await _httpService.multipartPost(
          '/itinerary/', fields, filePaths,
          headers: getAuthenticationHeader(accessToken));
      return Itinerary.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Itinerary> editItinerary(
      String itineraryId,
      Map<String, String> fields,
      List<String> filePaths,
      String accessToken) async {
    try {
      var response = await _httpService.multipartPut(
          '/itinerary/$itineraryId/', fields, filePaths,
          headers: getAuthenticationHeader(accessToken));
      return Itinerary.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItinerary(String id, String accessToken) async {
    await _httpService.delete('/itinerary/$id/',
        headers: getAuthenticationHeader(accessToken));
  }
}
