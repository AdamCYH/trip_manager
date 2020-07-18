import 'package:flutter/material.dart';
import 'package:mobile/http/API.dart';
import 'package:mobile/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static const String ACCESS_TOKEN_STORAGE_KEY = 'access';
  static const String REFRESH_TOKEN_STORAGE_KEY = 'refresh';

  // TODO: Should be replaced by secure keystore
  SharedPreferences _prefs;

  User currentUser;
  final API _api = API();

  bool tokensAvailable = false;
  String accessToken;
  String refreshToken;
  bool _isLoginPageHidden = true;

  get isLoginPageHidden => _isLoginPageHidden;

  set isLoginPageHidden(bool val) {
    _isLoginPageHidden = val;
    notifyListeners();
  }

  AuthService() {
    _getStorage().then((value) => _getTokensFromStorage());
  }

  Future<void> _getStorage() async {
    _prefs = await SharedPreferences.getInstance();
    print('got storage');
  }

  Future getUser() {
    return Future.value(currentUser);
  }

  // wrapping the firebase calls
  Future createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {}

  User login({String username, String password}) {
    _api.login(username, password, (user) {
      if (user.userId != null) {
        currentUser = user;
        _prefs.setString(ACCESS_TOKEN_STORAGE_KEY, user.accessToken);
        _prefs.setString(REFRESH_TOKEN_STORAGE_KEY, user.refreshToken);
      } else {
        currentUser = null;
      }
      // TODO if successful, hide login page
      _getTokensFromStorage();
      notifyListeners();
    });

    return currentUser;
  }

  Future logout() async {
    this.currentUser = null;
    _removeTokens();
    notifyListeners();
    return Future.value(currentUser);
  }

  void _getTokensFromStorage() {
    print('getting token');
    accessToken = _prefs.get(ACCESS_TOKEN_STORAGE_KEY);
    refreshToken = _prefs.get(REFRESH_TOKEN_STORAGE_KEY);
    if (accessToken != null && refreshToken != null) {
      print('Token available');
      tokensAvailable = true;
    } else {
      print('Token not available');
      tokensAvailable = false;
    }
  }

  void _removeTokens() {
    _prefs.remove(ACCESS_TOKEN_STORAGE_KEY);
    _prefs.remove(REFRESH_TOKEN_STORAGE_KEY);
    accessToken = null;
    refreshToken = null;
    tokensAvailable = false;
  }

  Future authenticate() {
    return null;
  }
}
