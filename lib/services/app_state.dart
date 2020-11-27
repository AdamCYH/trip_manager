import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/models/models.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/services/routing_service.dart';

class AppState with ChangeNotifier {
  AuthService authService;
  ApiService apiService;
  RoutingService routingService;
  NotificationService notificationService;

  Map<String, Featured> featuredItinerariesMap =
      new LinkedHashMap<String, Featured>();

  Map<String, Itinerary> hotItinerariesMap =
      new LinkedHashMap<String, Itinerary>();

  Map<String, Itinerary> myItinerariesMap =
      new LinkedHashMap<String, Itinerary>();

  AppState() {
    log('Init app state');
    this.authService = AuthService(this);
    this.apiService = ApiService();
    this.routingService = RoutingService();
    this.notificationService = NotificationService();
  }

  void notifyChanges() {
    notifyListeners();
  }

  String getAccessToken() {
    return authService.currentAuth == null ||
            authService.currentAuth.accessToken == null
        ? ''
        : authService.currentAuth.accessToken;
  }

  ///###########
  /// API CALLS
  ///###########

  Future<User> createUser(User user) async {
    var userName = user.userName;
    var password = user.password;
    try {
      authService.currentUser = await apiService.createUser(user);
      authService.login(username: userName, password: password);
      notifyChanges();
      return authService.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, Featured>> getFeaturedList(
      {Key key, forceGet = false}) async {
    if (forceGet || featuredItinerariesMap.isEmpty) {
      featuredItinerariesMap = await apiService.getFeaturedItineraries();
      notifyChanges();
    }
    return featuredItinerariesMap;
  }

  Future<Map<String, Itinerary>> getHotList({Key key, forceGet = false}) async {
    if (forceGet || hotItinerariesMap.isEmpty) {
      hotItinerariesMap = await apiService.getHotItineraries();
      notifyChanges();
    }
    return hotItinerariesMap;
  }

  Future<Map<String, Itinerary>> getMyItinerariesList(
      {Key key, forceGet = false}) async {
    if (forceGet || myItinerariesMap.isEmpty) {
      myItinerariesMap = await apiService.getMyItineraries(
          authService.currentAuth.accessToken, authService.currentAuth.userId);
      notifyChanges();
    }
    return myItinerariesMap;
  }

  Future<void> createItinerary(
      Map<String, String> fields, List<String> filePaths) async {
    try {
      var itinerary = await apiService.createItinerary(
          fields, filePaths, authService.currentAuth.accessToken);
      var tempMap = new Map.from(myItinerariesMap);
      myItinerariesMap.clear();
      myItinerariesMap[itinerary.id] = itinerary;
      tempMap.forEach((key, value) {
        myItinerariesMap[key] = value;
      });
      notifyChanges();
    } catch (e) {
      rethrow;
    }
  }

  Future<Itinerary> editItinerary(String itineraryId,
      Map<String, String> fields, List<String> filePaths) async {
    try {
      var itinerary = await apiService.editItinerary(
          itineraryId, fields, filePaths, authService.currentAuth.accessToken);
      myItinerariesMap[itineraryId] = itinerary;
      notifyChanges();
      return itinerary;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItinerary(String id) async {
    try {
      await apiService.deleteItinerary(id, authService.currentAuth.accessToken);
      myItinerariesMap.remove(id);
      notifyChanges();
    } catch (e) {
      rethrow;
    }
  }
}
