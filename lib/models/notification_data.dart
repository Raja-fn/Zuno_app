import 'package:flutter/material.dart';

class NotificationData {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  NotificationData({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });
}
