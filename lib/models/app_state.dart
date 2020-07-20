import 'package:flutter/material.dart';
import 'package:mobile/models/auth_service.dart';

class AppState with ChangeNotifier {
  AuthService authService;

  AppState() {
    this.authService = AuthService(this);
  }

  bool _isLoginPageShown = false;

  bool _isErrorMessageShown = false;

  get isLoginPageShown => _isLoginPageShown;

  set isLoginPageShown(bool val) {
    _isLoginPageShown = val;
    notifyListeners();
  }

}
