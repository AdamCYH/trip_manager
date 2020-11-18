import 'package:flutter/material.dart';

class NotificationService {
  NotificationService();

  void showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
