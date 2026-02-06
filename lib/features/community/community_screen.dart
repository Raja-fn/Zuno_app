import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/community_model.dart';
import '../../services/community_service.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/features/feed/models/post_model.dart';
import 'package:zuno/shared/post_card.dart';

// Mood-based UI for Community section
enum Mood {
  Happy,
  Adventurous,
  Calm,
  Focused,
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final service = CommunityService();
  final PostService _postService = PostService();

  // Mood feature
  Mood _currentMood = Mood.Happy;
  List<PostModel> _reels = [];
  bool _reelsLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReels();
  }

  // ─────────────────────────
  // MOOD & CONTENT
  // ─────────────────────────
  String _moodLabel(Mood m) {
    switch (m) {
      case Mood.Happy:
        return 'Happy';
      case Mood.Adventurous:
        return 'Adventurous';
      case Mood.Calm:
        return 'Calm';
      case Mood.Focused:
        return 'Focused';
    }
  }

  LinearGradient _moodGradient(Mood m) {
    switch (m) {
      case Mood.Happy:
        return const LinearGradient(colors: [Colors.orange, Colors.pink], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case Mood.Adventurous:
        return const LinearGradient(colors: [Colors.red, Colors.orange], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case Mood.Calm:
        return const LinearGradient(colors: [Colors.blue, Colors.cyan], begin: Alignment.topLeft, end: Alignment.bottomRight);
      case Mood.Focused:
        return const LinearGradient(colors: [Colors.indigo, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight);
    }
  }

  Future<void> _loadReels() async {
    setState(() { _reelsLoading = true; });
    final reels = await _postService.fetchReelsPaged(limit: 6, offset: 0);
    setState(() {
      _reels = reels;
      _reelsLoading = false;
    });
  }

  Widget _buildMoodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        children: [
          Text('Mood:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: Mood.values.map((m) {
                final selected = _currentMood == m;
                return ChoiceChip(
                  label: Text(_moodLabel(m)),
                  selected: selected,
                  onSelected: (sel) {
                    if (sel) {
                      setState(() {
                        _currentMood = m;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelsCarousel() {
    if (_reelsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_reels.isEmpty) {
      return const Center(child: Text('No reels yet'));
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 260,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
      items: _reels.map((r) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: PostCard(post: r),
        );
      }).toList(),
    );
  }

  Widget _communityListWrapper() {
    // Keeps existing structure for Explore/Joined lists
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _communityList(service.fetchExploreCommunities(), joinable: true),
          _communityList(service.fetchJoinedCommunities()),
        ],
      ),
    );
  }

  Widget _communityList(Future<List<Community>> future, {bool joinable = false}) {
    return FutureBuilder<List<Community>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final communities = snapshot.data!;
        if (communities.isEmpty) {
          return const Center(child: Text("Nothing here yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final c = communities[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(c.name),
                subtitle: Text("${c.members} members"),
                trailing: joinable
                    ? ElevatedButton(
                        onPressed: () async {
                          await service.joinCommunity(c.id);
                          setState(() {});
                        },
                        child: const Text("Join"),
                      )
                    : const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Explore"),
            Tab(text: "Joined"),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: _moodGradient(_currentMood),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoodSelector(),
            const SizedBox(height: 8),
            // Reels feed as a sliding card style section
            SizedBox(height: 260, child: _buildReelsCarousel()),
            // Main lists
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _communityList(service.fetchExploreCommunities(), joinable: true),
                  _communityList(service.fetchJoinedCommunities()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
