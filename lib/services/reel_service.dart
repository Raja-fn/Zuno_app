import '../features/clips/models/reel_model.dart';

class ReelService {
  Future<List<ReelModel>> fetchReels() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ReelModel(
        id: '1',
        title: 'Jaipur Vibes',
        thumbnailUrl: 'https://picsum.photos/300/300?1',
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        communityTag: 'city:Jaipur',
      ),
      ReelModel(
        id: '2',
        title: 'College Life',
        thumbnailUrl: 'https://picsum.photos/300/300?2',
        videoUrl: 'https://www.w3schools.com/html/movie.mp4',
        communityTag: 'college:Jaipur National University',
      ),
      ReelModel(
        id: '3',
        title: 'Diwali Celebration',
        thumbnailUrl: 'https://picsum.photos/300/300?3',
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        communityTag: 'festival:Diwali',
      ),
    ];
  }
}
