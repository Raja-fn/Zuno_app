import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'models/reel_model.dart';
import '../../core/design/zuno_colors.dart';
import '../../core/design/zuno_text.dart';

class ReelPlayerScreen extends StatefulWidget {
  final ReelModel reel;
  const ReelPlayerScreen({Key? key, required this.reel}) : super(key: key);

  @override
  State<ReelPlayerScreen> createState() => _ReelPlayerScreenState();
}

class _ReelPlayerScreenState extends State<ReelPlayerScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.reel.videoUrl);
    _controller.initialize().then((_) {
      setState(() {
        _initialized = true;
      });
      _controller.play();
    });
  }

  @override
 void dispose() {
   _controller.dispose();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZunoColors.background,
      appBar: AppBar(title: Text(widget.reel.title, style: ZunoText.heading()), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: _initialized
            ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
            : const CircularProgressIndicator(),
      ),
    );
  }
}
