import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/login_screen.dart';
import '../../features/profile/profile_setup_screen.dart';
import '../../features/navigation/main_navigation.dart';
import '../../services/profile_service.dart';

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  final _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    // 1️⃣ Not logged in → Login
    if (user == null) {
      return const LoginScreen();
    }

    // 2️⃣ Logged in → Check profile
    return FutureBuilder<bool>(
      future: _profileService.hasProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 3️⃣ No profile → Setup screen
        if (snapshot.data == false) {
          return const ProfileSetupScreen();
        }

        // 4️⃣ All good → Dashboard
        return const MainNavigation();
      },
    );
  }
}
