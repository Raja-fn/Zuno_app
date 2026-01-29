import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _bio = TextEditingController();
  final _city = TextEditingController();
  final _college = TextEditingController();

  Future<void> _updateProfile() async {
    final user = Supabase.instance.client.auth.currentUser!;
    await Supabase.instance.client
        .from('profiles')
        .update({
      'bio': _bio.text,
      'city': _city.text,
      'college': _college.text,
    })
        .eq('id', user.id);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _bio, decoration: const InputDecoration(labelText: "Bio")),
            TextField(controller: _city, decoration: const InputDecoration(labelText: "City")),
            TextField(controller: _college, decoration: const InputDecoration(labelText: "College")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
