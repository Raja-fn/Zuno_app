import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'reel_player_screen.dart';
import '../../core/design/zuno_colors.dart';
import '../../core/design/zuno_text.dart';
import 'models/reel_model.dart';
import '../../services/reel_service.dart';

class ClipsScreen extends StatefulWidget {
  const ClipsScreen({Key? key}) : super(key: key);
  @override
  State<ClipsScreen> createState() => _ClipsScreenState();
}

class _ClipsScreenState extends State<ClipsScreen> {
  late Future<List<ReelModel>> _reelsFuture;

  @override
  void initState() {
    super.initState();
    _reelsFuture = ReelService().fetchReels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,
      appBar: AppBar(
        title: Text('Reels', style: ZunoText.heading()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<ReelModel>>(
        future: _reelsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reels = snapshot.data!;
          if (reels.length > 1) {
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: reels.length,
              itemBuilder: (ctx, idx) => ReelPlayerScreen(reel: reels[idx]),
            );
          } else {
            return ReelPlayerScreen(reel: reels.first);
          }
        },
      ),
    );
  }
}
