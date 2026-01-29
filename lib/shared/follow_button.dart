import 'package:flutter/material.dart';
import '../services/follow_service.dart';

class FollowButton extends StatefulWidget {
  final String userId;

  const FollowButton({super.key, required this.userId});

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _isFollowing = await FollowService().isFollowing(widget.userId);
    if (mounted) setState(() {});
  }

  Future<void> _toggle() async {
    if (_isFollowing) {
      await FollowService().unfollowUser(widget.userId);
    } else {
      await FollowService().followUser(widget.userId);
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _toggle,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFollowing ? Colors.grey : Colors.black,
      ),
      child: Text(_isFollowing ? "Following" : "Follow"),
    );
  }
}
