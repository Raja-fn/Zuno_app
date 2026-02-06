class ChatModel {
  final String id;
  final String otherUserId;
  final String otherUsername;
  final String? otherAvatar;
  final String lastMessage;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.otherUserId,
    required this.otherUsername,
    this.otherAvatar,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory ChatModel.fromMap(
      Map<String, dynamic> map,
      String currentUserId,
      ) {
    final isUser1 = map['user1']['id'] != currentUserId;
    final otherUser = isUser1 ? map['user1'] : map['user2'];

    return ChatModel(
      id: map['id'],
      otherUserId: otherUser['id'],
      otherUsername: otherUser['username'],
      otherAvatar: otherUser['avatar_url'],
      lastMessage: map['last_message'] ?? '',
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
