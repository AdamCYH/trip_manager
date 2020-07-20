import 'package:flutter/material.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/app_state.dart';
import 'package:mobile/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String ACCESS_TOKEN_STORAGE_KEY = 'access';
  static const String REFRESH_TOKEN_STORAGE_KEY = 'refresh';

  // TODO: Should be replaced by secure keystore
  SharedPreferences _prefs;

  User currentUser;
  final API _api = API();
  final AppState appState;

  String accessToken;
  String refreshToken;

  AuthStatus authStatus = AuthStatus.UNAUTHENTICATED;

  AuthService(this.appState) {
    _getStorage().then((value) => _getTokensFromStorage());
  }

  Future<void> _getStorage() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future getUser() {
    return Future.value(currentUser);
  }

  Future createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {}

  Future login({String username, String password}) {
    _api.login(username, password, (user) {
      if (user.userId != null) {
        currentUser = user;
        _prefs.setString(ACCESS_TOKEN_STORAGE_KEY, user.accessToken);
        _prefs.setString(REFRESH_TOKEN_STORAGE_KEY, user.refreshToken);
        authStatus = AuthStatus.AUTHENTICATED;
      } else {
        currentUser = null;
        authStatus = AuthStatus.UNAUTHORIZED;
      }
      _getTokensFromStorage();
      appState.notifyChanges();
    });

    return Future.value(currentUser);
  }

  Future logout() async {
    this.currentUser = null;
    _removeTokens();
    authStatus = AuthStatus.UNAUTHENTICATED;
    appState.notifyChanges();
    return Future.value(currentUser);
  }

  void _getTokensFromStorage() {
    accessToken = _prefs.get(ACCESS_TOKEN_STORAGE_KEY);
    refreshToken = _prefs.get(REFRESH_TOKEN_STORAGE_KEY);
  }

  void _removeTokens() {
    _prefs.remove(ACCESS_TOKEN_STORAGE_KEY);
    _prefs.remove(REFRESH_TOKEN_STORAGE_KEY);
    accessToken = null;
    refreshToken = null;
  }

  Future authenticate() {
    return null;
  }
}

enum AuthStatus {
  UNAUTHENTICATED, // -> Login
  AUTHENTICATING, // -> Profile page
  AUTHENTICATED,
  UNAUTHORIZED
}
