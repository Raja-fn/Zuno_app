class CommentData {
  final String id;
  final String postId;
  final String username;
  final String content;
  final DateTime createdAt;

  CommentData({
    required this.id,
    required this.postId,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      id: json['id'].toString(),
      postId: json['post_id'],
      username: json['username'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
