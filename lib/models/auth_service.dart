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
  Auth currentAuth;

  final API _api = API();
  final AppState appState;

  String accessToken;
  String refreshToken;

  AuthStatus authStatus = AuthStatus.UNAUTHENTICATED;

  AuthService(this.appState) {
    _getStorage()
        .then((value) => _getTokensFromStorage())
        .then((value) => refreshNewToken());
  }

  Future<void> _getStorage() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future getUser(String userId) async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTk1Mzc1NDI5LCJqdGkiOiJkNGM5YmVkYWUzNDQ0YjBiYmJhMzQwNjZkODAyMzhhNSIsInVzZXJfaWQiOiI2ZDBmNjU1ZS0xNmZjLTRhY2ItODgzOS1mMjRjYzkwZTQ5NTQifQ.rZfSxpb7dJUapsyKHsFZLqG9vDefnivrmotTQVb9UcM';
    return await _api.getUser(token, refreshToken, userId, this);
  }

  Future createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {}

  Future login({String username, String password}) {
    _api.login(username, password, (auth) async {
      if (auth != null) {
        currentAuth = auth;
        accessToken = auth.accessToken;
        refreshToken = auth.refreshToken;
        _prefs.setString(ACCESS_TOKEN_STORAGE_KEY, auth.accessToken);
        _prefs.setString(REFRESH_TOKEN_STORAGE_KEY, auth.refreshToken);
        authStatus = AuthStatus.AUTHENTICATED;

        currentUser = await getUser(auth.userId);
      } else {
        authStatus = AuthStatus.UNAUTHENTICATED;
      }
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

  Future refreshNewToken() async {
    _api.refreshToken(refreshToken, (token) {
      token == null
          ? authStatus = AuthStatus.UNAUTHENTICATED
          : authStatus = AuthStatus.AUTHENTICATED;
      accessToken = token;
    });
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
  AUTHENTICATED
}
