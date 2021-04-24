import 'package:flutter/material.dart';

class NotificationService {
  NotificationService();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
