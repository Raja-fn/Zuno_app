import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../navigation/main_navigation.dart';
import '../onboarding/follow_suggestions_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final usernameCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  File? avatar;
  bool loading = false;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => avatar = File(picked.path));
    }
  }

  Future<void> _completeProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() => loading = true);

    String? avatarUrl;

    // 1️⃣ Upload avatar
    if (avatar != null) {
      final path = '${user.id}/avatar.jpg';

      await _supabase.storage.from('avatars').upload(
        path,
        avatar!,
        fileOptions: const FileOptions(upsert: true),
      );

      avatarUrl =
          _supabase.storage.from('avatars').getPublicUrl(path);
    }

    // 2️⃣ Update profile
    await _supabase.from('profiles').update({
      'username': usernameCtrl.text.trim(),
      'bio': bioCtrl.text.trim(),
      'avatar_url': avatarUrl,
    }).eq('id', user.id);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const FollowSuggestionsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set up profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            GestureDetector(
              onTap: _pickAvatar,
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                avatar != null ? FileImage(avatar!) : null,
                child: avatar == null
                    ? const Icon(Icons.add_a_photo, size: 28)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(
                hintText: "Username",
                filled: true,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Bio",
                filled: true,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _completeProfile,
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
