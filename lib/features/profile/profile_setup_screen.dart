import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../navigation/main_navigation.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _usernameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  bool loading = false;

  Future<void> _saveProfile() async {
    if (_usernameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Username required")));
      return;
    }

    setState(() => loading = true);

    final user = Supabase.instance.client.auth.currentUser!;

    try {
      await Supabase.instance.client.from('profiles').insert({
        'id': user.id,
        'username': _usernameCtrl.text.trim(),
        'bio': _bioCtrl.text.trim(),
        'avatar_url': null,
      });

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
            (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set up your profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                hintText: "Username",
                filled: true,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Bio (optional)",
                filled: true,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _saveProfile,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
