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

  Future<List<Featured>> getFeaturedList({Key key, forceGet = false}) async {
    if (forceGet || featuredList == null) {
      featuredList = await API().getFeaturedItineraries();
    }
    return featuredList;
  }

  Future<List<Itinerary>> getHotList({Key key, forceGet = false}) async {
    if (forceGet || hotList == null) {
      hotList = await API().getHotItineraries();
    }
    return hotList;
  }

  Future<List<Itinerary>> getMyItinerariesList({Key key, forceGet = false}) async {
    if (forceGet || myItinerariesList == null) {
      myItinerariesList = await API().getMyItineraries(authService.currentAuth.accessToken);
    }
    return myItinerariesList;
  }

}
