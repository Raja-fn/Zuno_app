import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/services/auth_service.dart';
import 'package:zuno/features/navigation/main_navigation.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../profile/profile_setup_screen.dart';

class ThreePanelAuthScreen extends StatefulWidget {
  const ThreePanelAuthScreen({Key? key}) : super(key: key);

  @override
  _ThreePanelAuthScreenState createState() => _ThreePanelAuthScreenState();
}

class _ThreePanelAuthScreenState extends State<ThreePanelAuthScreen> {
  // Login panel state
  final _loginEmail = TextEditingController();
  final _loginPw = TextEditingController();
  bool _loginLoading = false;
  // Sign up panel state
  final _signupUsername = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPw = TextEditingController();
  bool _signupLoading = false;
  // Reset panel state
  final _resetEmail = TextEditingController();
  bool _resetLoading = false;

  Future<void> _login() async {
    setState(() => _loginLoading = true);
      try {
      await AuthService().signIn(email: _loginEmail.text.trim(), password: _loginPw.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _loginLoading = false);
    }
  }

  Future<void> _signup() async {
    setState(() => _signupLoading = true);
    try {
      await AuthService().signUp(
        email: _signupEmail.text.trim(),
        password: _signupPw.text.trim(),
        username: _signupUsername.text.trim(),
      );
      if (!mounted) return;
      // After signup, go to profile setup (existing flow)
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen()));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _signupLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    setState(() => _resetLoading = true);
    try {
      await AuthService().resetPasswordForEmail(_resetEmail.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Reset link sent if email exists')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset failed: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _resetLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple three-panel layout; tweak styling to resemble the design in screenshot
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E9),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // LOGIN PANEL
            Expanded(child: _PanelCard(title: 'Login Page', child: _buildLogin() )),
            // SIGN UP PANEL
            Expanded(child: _PanelCard(title: 'Sign Up Page', child: _buildSignup() )),
            // RESET PANEL
            Expanded(child: _PanelCard(title: 'Reset Password', child: _buildReset() )),
          ],
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _loginEmail, decoration: const InputDecoration(labelText: 'Email', hintText: 'Email')),
          const SizedBox(height: 8),
          TextField(controller: _loginPw, obscureText: true, decoration: const InputDecoration(labelText: 'Password', hintText: 'Password')),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: _loginLoading ? const CircularProgressIndicator() : const Text('Login'))),
          TextButton(onPressed: () => _setPanel(2), child: const Text('Forgot password?')),
        ],
      ),
    );
  }

  Widget _buildSignup() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _signupUsername, decoration: const InputDecoration(labelText: 'Username')),
          const SizedBox(height: 8),
          TextField(controller: _signupEmail, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          TextField(controller: _signupPw, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _signup, child: _signupLoading ? const CircularProgressIndicator() : const Text('Create Account'))),
        ],
      ),
    );
  }

  Widget _buildReset() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reset Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _resetEmail, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _resetPassword, child: _resetLoading ? const CircularProgressIndicator() : const Text('Send Reset Link'))),
        ],
      ),
    );
  }

  void _setPanel(int idx) {
    // This is a simple placeholder to illustrate navigation between panels.
    // In a real app you might switch tabs or animate; here we do nothing.
  }
}

class _PanelCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _PanelCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade50,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
