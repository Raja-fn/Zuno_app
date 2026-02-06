import 'package:flutter/material.dart';

class MoodOption {
  final String id;
  final String label;
  MoodOption({required this.id, required this.label});
}

class MoodDiscovery extends StatefulWidget {
  final ValueChanged<String> onMoodSelected;
  const MoodDiscovery({Key? key, required this.onMoodSelected}) : super(key: key);

  @override
  _MoodDiscoveryState createState() => _MoodDiscoveryState();
}

class _MoodDiscoveryState extends State<MoodDiscovery> {
  final List<MoodOption> moods = [
    MoodOption(id: 'lofi', label: 'Lofi/Chill'),
    MoodOption(id: 'mc', label: 'Main Character'),
    MoodOption(id: 'delulu', label: 'Delulu'),
    MoodOption(id: 'hype', label: 'Hype'),
  ];
  String _selected = 'lofi';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        itemCount: moods.length,
        itemBuilder: (ctx, i) {
          final m = moods[i];
          final active = _selected == m.id;
          return GestureDetector(
            onTap: () {
              setState(() { _selected = m.id; });
              widget.onMoodSelected(m.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: active ? Colors.transparent : Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(0.6)),
                boxShadow: active
                    ? [BoxShadow(color: Colors.cyanAccent, blurRadius: 12, spreadRadius: 2)]
                    : [],
              ),
              child: Text(
                m.label,
                style: TextStyle(color: active ? Colors.white : Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }
}
