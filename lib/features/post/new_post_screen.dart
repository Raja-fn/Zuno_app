import 'package:flutter/material.dart';
import 'package:zuno/services/post_service.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _captionCtl = TextEditingController();
  bool _loading = false;

  Future<void> _publish() async {
    setState(() => _loading = true);
    try {
      await PostService().createPostSimple(caption: _captionCtl.text.trim(), imageUrl: null);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _captionCtl, decoration: const InputDecoration(labelText: 'Caption')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loading ? null : _publish, child: _loading ? const CircularProgressIndicator() : const Text('Publish')),
          ],
        ),
      ),
    );
  }
}
