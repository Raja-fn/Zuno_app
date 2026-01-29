import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/design/zuno_colors.dart';
import '../../core/design/zuno_spacing.dart';
import '../../core/design/zuno_text.dart';
import '../../shared/ui/zuno_button.dart';
import '../../shared/ui/zuno_input.dart';
import '../../services/profile_service.dart';
import '../navigation/main_navigation.dart';
import '../profile/profile_setup_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ZunoSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              /// Title
              Text(
                "Create account ✨",
                style: ZunoText.heading(),
              ),

              const SizedBox(height: 8),

              Text(
                "Join Zuno and start sharing",
                style: ZunoText.bodyMuted(),
              ),

              const SizedBox(height: 40),

              /// Full name
              ZunoInput(
                hint: "Full name",
                controller: _nameController,
              ),

              /// Email
              ZunoInput(
                hint: "Email address",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              /// Password
              ZunoInput(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 24),

              /// Signup Button
              ZunoButton(
                text: "Sign up",
                onPressed: () async {
                  final fullName = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fill all fields")),
                    );
                    return;
                  }

                  try {
                    // 1️⃣ Create auth user
                    await Supabase.instance.client.auth.signUp(
                      email: email,
                      password: password,
                    );

                    // 2️⃣ Create profile
                    final profileService = ProfileService();
                    await profileService.createProfile(
                      username: email.split('@')[0],
                      fullName: fullName,
                    );

                    if (!context.mounted) return;

                    // 3️⃣ Navigate to dashboard
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
                    );
                  } on AuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message)),
                    );
                  } catch (e) {
        debugPrint("SIGNUP ERROR: $e");
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
        );
        }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
