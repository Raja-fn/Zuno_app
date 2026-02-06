import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../navigation/main_navigation.dart';
import 'login_screen.dart';
import '../profile/profile_setup_screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();

  bool loading = false;

  Future<void> _signup() async {
    setState(() => loading = true);

    try {
      await AuthService().signUp(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        username: usernameCtrl.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileSetupScreen(),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ZUNO",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // EMAIL
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  hintText: "Email",
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // USERNAME
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(
                  hintText: "Username",
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // PASSWORD
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              // SIGNUP BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : _signup,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Sign up"),
                ),
              ),

              const SizedBox(height: 20),

              // LOGIN LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
