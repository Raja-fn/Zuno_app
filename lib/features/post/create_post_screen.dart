import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zuno/services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<File> _selectedImages = [];
  bool _loading = false;

  // ─────────────────────────
  // PICK MULTIPLE IMAGES
  // ─────────────────────────
  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 85);

    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images.map((e) => File(e.path)).toList();
      });
    }
  }

  // ─────────────────────────
  // UPLOAD IMAGE → SUPABASE
  // ─────────────────────────
  Future<String> _uploadImage(File file) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser!;

    final fileName =
        '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('post-images').upload(
      fileName,
      file,
      fileOptions: const FileOptions(upsert: false),
    );

    return supabase.storage
        .from('post-images')
        .getPublicUrl(fileName);
  }

  // ─────────────────────────
  // SUBMIT POST
  // ─────────────────────────
  Future<void> _submitPost() async {
    final caption = captionController.text.trim();

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one image")),
      );
      return;
    }

    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Caption cannot be empty")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser!;
      final username = user.email?.split('@').first ?? 'user';

      // 🔥 Upload all images
      final imageUrls = <String>[];
      for (final file in _selectedImages) {
        final url = await _uploadImage(file);
        imageUrls.add(url);
      }

      // 🧠 Feed currently uses single image → use first
      await PostService().createPost(
        imageUrl: imageUrls.first,
        caption: caption,
        username: username,
        topics: _extractTopics(caption),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ─────────────────────────
  // AUTO TOPICS
  // ─────────────────────────
  List<String> _extractTopics(String caption) {
    final lower = caption.toLowerCase();
    final topics = <String>[];

    if (lower.contains('flutter')) topics.add('flutter');
    if (lower.contains('college')) topics.add('college');
    if (lower.contains('fitness') || lower.contains('gym')) {
      topics.add('fitness');
    }
    if (lower.contains('coding')) topics.add('coding');
    if (lower.contains('travel')) topics.add('travel');

    if (topics.isEmpty) topics.add('general');
    return topics;
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submitPost,
            child: _loading
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              "Share",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      // ───────── BODY ─────────
      body: Column(
        children: [
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: _selectedImages.isEmpty
                  ? const Center(
                child: Icon(Icons.add_a_photo, size: 40),
              )
                  : CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                ),
                items: _selectedImages.map((file) {
                  return Image.file(
                    file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }).toList(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: captionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Write a caption...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
