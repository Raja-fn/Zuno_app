class PostData {
  final String id;
  final String username;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;
  final String time;

  PostData({
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.time,
  });

  factory PostData.fromMap(Map<String, dynamic> map) {
    return PostData(
      id: map['id'].toString(),
      username: map['username'] ?? 'User',
      imageUrl: map['image_url'] ?? '',
      caption: map['caption'] ?? '',
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      time: map['created_at'] ?? '',
    );
  }
}
