import 'package:flutter/material.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/app_state.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/services/routing_service.dart';
import 'package:provider/provider.dart';

class AuthProvider {
  static String accessToken(BuildContext context) =>
      Provider.of<AppState>(context, listen: false)
          .authService
          .currentAuth
          .accessToken;
}

class ServiceProvider {
  static ApiService apiService(BuildContext context) =>
      Provider.of<AppState>(context, listen: false).apiService;

  static AuthService authService(BuildContext context) =>
      Provider.of<AppState>(context, listen: false).authService;

  static RoutingService routingService(BuildContext context) =>
      Provider.of<AppState>(context, listen: false).routingService;

  static NotificationService notificationService(BuildContext context) =>
      Provider.of<AppState>(context, listen: false).notificationService;
}
