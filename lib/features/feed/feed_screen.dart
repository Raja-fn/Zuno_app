import 'package:flutter/material.dart';
import 'package:zuno/services/post_service.dart';
import 'package:zuno/shared/post_card.dart';
import 'package:zuno/features/post/create_post_screen.dart';
import 'package:zuno/features/feed/models/post_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<PostModel> _posts = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;
  bool _personalized = false;

  final int _pageSize = 10;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _loadMorePosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMorePosts();
      }
    });
  }

  // ─────────────────────────
  // LOAD POSTS (MODE AWARE)
  // ─────────────────────────
  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    List<PostModel> newPosts = [];

    if (_personalized) {
      newPosts = await PostService().fetchPersonalizedFeed(
        limit: _pageSize,
      );

      // 🔥 fallback for new users
      if (newPosts.isEmpty) {
        newPosts = await PostService().fetchPostsPaged(
          limit: _pageSize,
          offset: _offset,
        );
      }
    } else {
      newPosts = await PostService().fetchPostsPaged(
        limit: _pageSize,
        offset: _offset,
      );
    }

    setState(() {
      _posts.addAll(newPosts);

      if (!_personalized) {
        _offset += _pageSize;
      }

      _isLoading = false;
      _hasMore = newPosts.length == _pageSize;
    });
  }

  // ─────────────────────────
  // RESET & RELOAD
  // ─────────────────────────
  Future<void> _resetAndReloadFeed() async {
    setState(() {
      _posts.clear();
      _offset = 0;
      _hasMore = true;
    });

    await _loadMorePosts();
  }

  Future<void> _refreshFeed() async {
    await _resetAndReloadFeed();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      // ───────── APP BAR ─────────
      appBar: AppBar(
        title: Text(_personalized ? "For You" : "Latest"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              _personalized
                  ? Icons.auto_awesome
                  : Icons.access_time,
            ),
            tooltip: _personalized
                ? "Switch to Latest"
                : "Switch to For You",
            onPressed: () {
              setState(() => _personalized = !_personalized);
              _resetAndReloadFeed();
            },
          ),
        ],
      ),

      // ───────── FEED BODY ─────────
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: _posts.isEmpty && !_isLoading
            ? const Center(
          child: Text(
            "No posts yet.\nBe the first to post!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _posts.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _posts.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return PostCard(post: _posts[index]);
          },
        ),
      ),

      // ───────── CREATE POST ─────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePostScreen(),
            ),
          );

          if (created == true) {
            _refreshFeed();
          }
        },
      ),
    );
  }
}
