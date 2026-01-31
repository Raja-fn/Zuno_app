class PostModel {
  final String id;
  final String imageUrl;
  final List<String> imageUrls;
  final String? videoUrl;
  final String caption;
  final String username;
  final DateTime createdAt;

  bool isLiked;
  int likesCount;
  int commentsCount;

  PostModel({
    required this.id,
    required this.imageUrl,
    required this.imageUrls,
    required this.caption,
    required this.username,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    this.videoUrl,
  });

  factory PostModel.fromMap(
      Map<String, dynamic> map, {
        String? currentUserId,
      }) {
    final likes = map['likes'] as List? ?? [];

    final List<String> imageUrls =
        (map['image_urls'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
            (map['image_url'] != null
                ? [map['image_url'].toString()]
                : []);

    return PostModel(
      id: map['id'].toString(),
      imageUrl: imageUrls.isNotEmpty ? imageUrls.first : '',
      imageUrls: imageUrls,
      videoUrl: map['video_url'], // 🎥
      caption: map['caption'] ?? '',
      username: map['username'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      likesCount: map['likes_count'] ?? likes.length,
      isLiked: currentUserId != null &&
          likes.any((l) => l['user_id'] == currentUserId),
      commentsCount: map['comments_count'] ?? 0,
    );
  }
}
