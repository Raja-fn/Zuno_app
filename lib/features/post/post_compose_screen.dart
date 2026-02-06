import 'package:flutter/material.dart';
import 'package:zuno/services/post_service.dart';

class PostComposeScreen extends StatefulWidget {
  const PostComposeScreen({Key? key}) : super(key: key);

  @override
  State<PostComposeScreen> createState() => _PostComposeScreenState();
}

class _PostComposeScreenState extends State<PostComposeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _captionCtrl = TextEditingController();
  bool _publishing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      // For now we just create a simple post with caption. Different content types can be added later.
      await PostService().createPostSimple(caption: _captionCtrl.text.trim(), imageUrl: null);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Publish failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Reel'), Tab(text: 'Photo')],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Caption'),
                  TextField(controller: _captionCtrl),
                  const SizedBox(height: 12),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _publishing ? null : _publish,
              child: _publishing ? const CircularProgressIndicator() : const Text('Publish'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ),
        ],
      ),
    );
  }
}
