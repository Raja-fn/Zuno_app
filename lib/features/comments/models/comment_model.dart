class CommentModel {
  final String id;
  final String username;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      username: map['username'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
