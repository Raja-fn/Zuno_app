import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:zuno/features/feed/models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          _PostMedia(post: post),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(post.caption),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────
// MEDIA HANDLER
// ─────────────────────────
class _PostMedia extends StatelessWidget {
  final PostModel post;

  const _PostMedia({required this.post});

  @override
  Widget build(BuildContext context) {
    // 🎥 VIDEO POST
    if (post.videoUrl != null && post.videoUrl!.isNotEmpty) {
      return _VideoPlayer(url: post.videoUrl!);
    }

    // 📸 MULTI IMAGE
    if (post.imageUrls.length > 1) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 300,
          viewportFraction: 1,
          enableInfiniteScroll: false,
        ),
        items: post.imageUrls.map((url) {
          return Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
          );
        }).toList(),
      );
    }

    // 📸 SINGLE IMAGE
    if (post.imageUrls.isNotEmpty) {
      return Image.network(
        post.imageUrls.first,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    // ❌ FALLBACK
    return const SizedBox(
      height: 300,
      child: Center(child: Icon(Icons.image)),
    );
  }
}

// ─────────────────────────
// VIDEO PLAYER (AUTOPLAY)
// ─────────────────────────
class _VideoPlayer extends StatefulWidget {
  final String url;

  const _VideoPlayer({required this.url});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
