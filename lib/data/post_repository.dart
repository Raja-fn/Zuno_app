import '../models/post_data.dart';

class PostRepository {
  static final List<PostData> posts = [
    PostData(
      username: "Aman",
      time: "2h ago",
      imageUrl: "https://picsum.photos/400/300?1",
      likes: 120,
      comments: 30,
      community: CommunityType.city,
    ),
    PostData(
      username: "Riya",
      time: "1h ago",
      imageUrl: "https://picsum.photos/400/300?2",
      likes: 95,
      comments: 18,
      community: CommunityType.college,
    ),
    PostData(
      username: "Rahul",
      time: "Just now",
      imageUrl: "https://picsum.photos/400/300?3",
      likes: 210,
      comments: 55,
      community: CommunityType.festival,
    ),
    PostData(
      username: "Neha",
      time: "5m ago",
      imageUrl: "https://picsum.photos/400/300?4",
      likes: 60,
      comments: 12,
      community: CommunityType.city,
    ),
  ];

  static List<PostData> getAll() => posts;

  static List<PostData> getByCommunity(CommunityType type) {
    return posts.where((p) => p.community == type).toList();
  }
}
