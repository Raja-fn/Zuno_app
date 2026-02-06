class ProfileData {
  final String userId;
  final String username;
  final String bio;
  final String city;
  final String college;
  final String avatarUrl;
  final int followersCount;
  final int followingCount;

  ProfileData({
    required this.userId,
    required this.username,
    required this.bio,
    required this.city,
    required this.college,
    required this.avatarUrl,
    required this.followersCount,
    required this.followingCount,
  });

  factory ProfileData.fromMap(Map<String, dynamic> map) {
    final uid = (map['user_id'] ?? map['id'] ?? '').toString();
    return ProfileData(
      userId: uid,
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      city: map['city'] ?? '',
      college: map['college'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
      followersCount: (map['followers_count'] ?? 0) as int,
      followingCount: (map['following_count'] ?? 0) as int,
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
      'followers_count': followersCount,
      'following_count': followingCount,
    };
  }
}
