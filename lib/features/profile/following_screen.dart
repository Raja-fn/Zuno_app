import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  late Future<List<Map<String, dynamic>>> _followingFuture;

  final String _userId =
      Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _followingFuture = _fetchFollowing();
  }

  Future<List<Map<String, dynamic>>> _fetchFollowing() async {
    final res = await Supabase.instance.client
        .from('follows')
        .select('following_id')
        .eq('follower_id', _userId);

    return List<Map<String, dynamic>>.from(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Following",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _followingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Not following anyone yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final following = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: following.length,
            itemBuilder: (context, index) {
              final followingId =
              following[index]['following_id'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        followingId, // 🔥 TEMP (replace with username later)
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: Colors.grey),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
