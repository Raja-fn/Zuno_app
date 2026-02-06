import 'package:flutter/material.dart';
import 'package:zuno/models/profile_data.dart';
import 'package:zuno/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileData profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _service = ProfileService();

  late TextEditingController usernameCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController collegeCtrl;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    usernameCtrl = TextEditingController(text: widget.profile.username);
    bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
    cityCtrl = TextEditingController(text: widget.profile.city ?? '');
    collegeCtrl = TextEditingController(text: widget.profile.college ?? '');
  }

  Future<void> _save() async {
    setState(() => saving = true);

    try {
      await _service.updateProfile(
        username: usernameCtrl.text.trim(),
        bio: bioCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        college: collegeCtrl.text.trim(),
        userId: widget.profile.userId,
      );
    } catch (e) {
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          TextButton(
            onPressed: saving ? null : _save,
            child: saving
                ? const CircularProgressIndicator()
                : const Text("Save"),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field("Username", usernameCtrl),
          _field("Bio", bioCtrl, maxLines: 3),
          _field("City", cityCtrl),
          _field("College", collegeCtrl),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            decoration: const InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
