class ProfileData {
  final String userId;
  final String username;
  final String bio;
  final String city;
  final String college;
  final String avatarUrl;

  ProfileData({
    required this.userId,
    required this.username,
    required this.bio,
    required this.city,
    required this.college,
    required this.avatarUrl,
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) {
    return ProfileData(
      userId: map['user_id'],
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      city: map['city'] ?? '',
      college: map['college'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'bio': bio,
      'city': city,
      'college': college,
      'avatar_url': avatarUrl,
    };
  }
}
