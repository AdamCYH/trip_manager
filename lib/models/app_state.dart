import 'package:flutter/material.dart';
import 'package:mobile/models/auth_service.dart';

class AppState with ChangeNotifier {
  AuthService authService;

  AppState() {
    this.authService = AuthService(this);
  }

  bool _isErrorMessageShown = false;

  void notifyChanges() {
    notifyListeners();
  }

}
