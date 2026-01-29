import 'package:flutter/material.dart';
import '../../core/design/zuno_colors.dart';
import '../../core/design/zuno_text.dart';
import '../../core/design/zuno_spacing.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: ZunoText.heading()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ZunoColors.gradientStart, ZunoColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _postCard('Welcome to Zuno', 'https://picsum.photos/800/400', 'Be Local'),
          _postCard('City Pulse', 'https://picsum.photos/seed/1/800/400', 'Be Real'),
          _postCard('Be Now', 'https://picsum.photos/seed/2/800/400', 'Live'),
        ],
      ),
    );
  }

  Widget _postCard(String title, String image, String mood) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title, style: ZunoText.heading()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Text(mood, style: ZunoText.body()),
          ),
        ],
      ),
    );
  }
}
