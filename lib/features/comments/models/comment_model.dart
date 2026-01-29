class CommentModel {
  final String id;
  final String postId;
  final String content;
  final DateTime createdAt;
  final String? username;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    this.username,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['post_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      username: json['username'],
    );
  }
}
