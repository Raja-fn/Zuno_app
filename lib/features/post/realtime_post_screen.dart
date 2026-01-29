import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/zuno_colors.dart';
import '../../services/storage_service.dart';
import '../../services/feed_service.dart';
import 'mood_selector.dart';

class RealtimePostScreen extends StatefulWidget {
  const RealtimePostScreen({super.key});

  @override
  State<RealtimePostScreen> createState() => _RealtimePostScreenState();
}

class _RealtimePostScreenState extends State<RealtimePostScreen> {
  File? image;
  String selectedMood = "😄 Chill";

  final picker = ImagePicker();
  final storageService = StorageService();
  final feedService = FeedService();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  Future<void> post() async {
    if (image == null) return;

    final imageUrl = await storageService.uploadPostImage(image!);
    await feedService.createPost(
      imageUrl: imageUrl,
      mood: selectedMood,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,
      body: Stack(
        children: [
          Center(
            child: image == null
                ? const Icon(Icons.camera_alt,
                size: 70, color: ZunoColors.textMuted)
                : Image.file(image!, fit: BoxFit.cover),
          ),

          // Top bar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: ZunoColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(selectedMood,
                    style: const TextStyle(color: ZunoColors.textPrimary)),
                const SizedBox(width: 24),
              ],
            ),
          ),

          // Bottom bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: ZunoColors.card,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions,
                        color: ZunoColors.primary),
                    onPressed: () async {
                      final mood = await showModalBottomSheet<String>(
                        context: context,
                        backgroundColor: ZunoColors.card,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        builder: (_) => const MoodSelector(),
                      );
                      if (mood != null) {
                        setState(() => selectedMood = mood);
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: image == null ? pickImage : post,
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: ZunoColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        image == null ? Icons.camera : Icons.check,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Icon(Icons.cameraswitch, color: ZunoColors.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
