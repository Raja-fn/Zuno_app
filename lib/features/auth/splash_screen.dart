import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/zuno_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Splash delay (2 seconds)
    Timer(const Duration(seconds: 2), () {
      widget.onFinish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo / Icon
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: ZunoColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: ZunoColors.primary.withOpacity(0.6),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: Colors.black,
                size: 42,
              ),
            ),

            const SizedBox(height: 28),

            // App Name
            const Text(
              "ZUNO",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: ZunoColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            const Text(
              "Real • Local • Now",
              style: TextStyle(
                fontSize: 14,
                color: ZunoColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
