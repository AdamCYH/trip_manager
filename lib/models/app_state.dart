import 'package:flutter/material.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/auth_service.dart';
import 'package:mobile/models/models.dart';

class AppState with ChangeNotifier {
  AuthService authService;

  List<Featured> featuredList;

  List<Itinerary> hotList;

  List<Itinerary> myItinerariesList;

  AppState() {
    this.authService = AuthService(this);
  }

  bool _isErrorMessageShown = false;

  void notifyChanges() {
    notifyListeners();
  }

  String getAccessToken() {
    return authService.currentAuth == null ||
            authService.currentAuth.accessToken == null
        ? ''
        : authService.currentAuth.accessToken;
  }

  Future<List<Featured>> getFeaturedList({Key key, forceGet = false}) async {
    if (forceGet || featuredList == null) {
      featuredList = await API().getFeaturedItineraries();
      notifyChanges();
    }
    return featuredList;
  }

  Future<List<Itinerary>> getHotList({Key key, forceGet = false}) async {
    if (forceGet || hotList == null) {
      hotList = await API().getHotItineraries();
      notifyChanges();
    }
    return hotList;
  }

  Future<List<Itinerary>> getMyItinerariesList(
      {Key key, forceGet = false}) async {
    if (forceGet || myItinerariesList == null) {
      myItinerariesList = await API().getMyItineraries(
          authService.currentAuth.accessToken, authService.currentAuth.userId);
      notifyChanges();
    }
    return myItinerariesList;
  }

  Future<void> createItinerary(
      Map<String, String> fields, List<String> filePaths) async {
    try {
      var iti = await API().createItinerary(
          fields, filePaths, authService.currentAuth.accessToken);
      myItinerariesList.insert(0, iti);
      notifyChanges();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItinerary(int index, String id) async {
    try {
      await API().deleteItinerary(id, authService.currentAuth.accessToken);
      myItinerariesList.removeAt(index);
      notifyChanges();
    } catch (e) {
      rethrow;
    }
  }
}
