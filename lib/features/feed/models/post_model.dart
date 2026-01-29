class PostModel {
  final String id;
  final String caption;
  final String username;
  final int likeCount;
  final String communityTag;

  // ✅ ADD THESE (they were missing)
  final String? city;
  final String? college;
  final String? region;

  PostModel({
    required this.id,
    required this.caption,
    required this.username,
    required this.likeCount,
    required this.communityTag,
    this.city,
    this.college,
    this.region,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id']?.toString() ?? '',
      caption: json['caption'] ?? '',
      username: json['username'] ?? 'User',
      likeCount: json['like_count'] ?? 0,
      communityTag: json['community_tag'] ?? 'city',

      // ✅ SAFE nullable parsing
      city: json['city'],
      college: json['college'],
      region: json['region'],
    );
  }
}
