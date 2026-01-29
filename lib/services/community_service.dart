import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/community_model.dart';

class CommunityService {
  final _supabase = Supabase.instance.client;

  String get userId => _supabase.auth.currentUser!.id;

  /// 🔎 EXPLORE (not joined)
  Future<List<Community>> fetchExploreCommunities() async {
    final data = await _supabase.rpc(
      'get_communities_excluding_user',
      params: {'uid': userId},
    );

    return data.map<Community>((c) => Community.fromMap(c)).toList();
  }

  /// ❤️ JOINED
  Future<List<Community>> fetchJoinedCommunities() async {
    final data = await _supabase.rpc(
      'get_user_joined_communities',
      params: {'uid': userId},
    );

    return data.map<Community>((c) => Community.fromMap(c)).toList();
  }

  Future<void> joinCommunity(String communityId) async {
    await _supabase.from('community_members').insert({
      'community_id': communityId,
      'user_id': userId,
    });
  }
}
