import 'package:flutter/material.dart';
import 'zuno_colors.dart';

class ZunoText {
  /// App logo / brand
  static TextStyle logo() {
    return const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      letterSpacing: -0.5,
    );
  }

  /// Main headings
  static TextStyle heading() {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  /// Normal body text
  static TextStyle body() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white70,
    );
  }

  /// Muted body text (descriptions, helpers)
  static TextStyle bodyMuted() {
    return const TextStyle(
      fontSize: 15,
      color: Colors.white60,
    );
  }

  /// Small caption text
  static TextStyle caption() {
    return const TextStyle(
      fontSize: 13,
      color: Colors.white60,
    );
  }

  /// Primary button text
  static TextStyle button() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  /// Links (Sign up / Login)
  static TextStyle link() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF00E5FF),
    );
  }
}
