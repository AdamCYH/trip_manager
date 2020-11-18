import 'package:flutter/material.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String ACCESS_TOKEN_STORAGE_KEY = 'access';
  static const String REFRESH_TOKEN_STORAGE_KEY = 'refresh';
  static const String USER_ID_STORAGE_KEY = 'userId';

  // TODO: Should be replaced by secure keystore
  SharedPreferences _prefs;

  User currentUser;
  Auth currentAuth;

  final ApiService _api = ApiService();
  final AppState appState;

  AuthStatus authStatus = AuthStatus.UNAUTHENTICATED;

  AuthService(this.appState) {
    _getStorage()
        .then((value) => _getAuthFromStorage())
        .then((value) => refreshNewToken());
  }

  Future<void> _getStorage() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<User> getUser({Key key, forceGet = false}) async {
    if (forceGet || currentUser == null) {
      currentUser = await _api.getUser(currentAuth.accessToken,
          currentAuth.refreshToken, currentAuth.userId, this);
    }
    appState.notifyChanges();
    return currentUser;
  }

  Future createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {}

  User login(
      {String username,
      String password,
      bool forceGetUser = false,
      BuildContext context}) {
    _api.login(username, password, (auth) async {
      if (auth != null) {
        currentAuth = auth;

        _prefs.setString(ACCESS_TOKEN_STORAGE_KEY, auth.accessToken);
        _prefs.setString(REFRESH_TOKEN_STORAGE_KEY, auth.refreshToken);
        _prefs.setString(USER_ID_STORAGE_KEY, auth.userId);
        authStatus = AuthStatus.AUTHENTICATED;
        Navigator.pop(context);

        if (forceGetUser) {
          currentUser = await getUser(forceGet: true);
        }
      } else {
        authStatus = AuthStatus.UNAUTHENTICATED;
        appState.notificationService.showSnackBar(context, '登录失败，请重新尝试。');
      }
      appState.notifyChanges();
    });
    return currentUser;
  }

  User logout() {
    this.currentUser = null;
    _removeAuth();
    authStatus = AuthStatus.UNAUTHENTICATED;
    appState.notifyChanges();
    return currentUser;
  }

  Future refreshNewToken() async {
    if (currentAuth != null) {
      _api.refreshToken(currentAuth.refreshToken, (token) {
        token == null
            ? authStatus = AuthStatus.UNAUTHENTICATED
            : authStatus = AuthStatus.AUTHENTICATED;
        currentAuth.accessToken = token;
      });
    }
  }

  bool get isUserLoggedIn => authStatus == AuthStatus.AUTHENTICATED;

  void _getAuthFromStorage() {
    var acc = _prefs.get(ACCESS_TOKEN_STORAGE_KEY);
    var ref = _prefs.get(REFRESH_TOKEN_STORAGE_KEY);
    var uid = _prefs.get(USER_ID_STORAGE_KEY);
    if (acc != null && ref != null && uid != null) {
      currentAuth =
          Auth.fromJson({'access': acc, 'refresh': ref, 'user_id': uid});
    }
  }

  void _removeAuth() {
    _prefs.remove(ACCESS_TOKEN_STORAGE_KEY);
    _prefs.remove(REFRESH_TOKEN_STORAGE_KEY);
    _prefs.remove(USER_ID_STORAGE_KEY);
    currentAuth = null;
  }

  Future authenticate() {
    return null;
  }
}

enum AuthStatus {
  UNAUTHENTICATED, // -> Login
  AUTHENTICATING, // -> Profile page
  AUTHENTICATED
}