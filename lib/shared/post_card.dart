import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String username;
  final String imageUrl;
  final int likes;
  final int comments;
  final String time;

  const PostCard({
    super.key,
    required this.postId,
    required this.username,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Image.network(imageUrl),
        Row(
          children: [
            Icon(Icons.favorite_border),
            Text(likes.toString()),
            const SizedBox(width: 16),
            Icon(Icons.comment),
            Text(comments.toString()),
          ],
        ),
        Text(time, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
