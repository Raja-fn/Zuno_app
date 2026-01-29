class ReelModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl; // ✅ REQUIRED
  final String communityTag;

  ReelModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.communityTag,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      communityTag: json['community_tag'] ?? '',
    );
  }
}
