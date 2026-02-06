import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zuno/services/jaipur_updates_service.dart' as jaipur_api;
import 'package:zuno/config/api_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JaipurUpdatesBanner extends StatefulWidget {
  const JaipurUpdatesBanner({Key? key}) : super(key: key);

  @override
  State<JaipurUpdatesBanner> createState() => _JaipurUpdatesBannerState();
}

class _JaipurUpdatesBannerState extends State<JaipurUpdatesBanner> {
  late jaipur_api.JaipurUpdatesService _service;
  List<jaipur_api.JaipurUpdate> _updates = [];
  bool _loading = true;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _service = jaipur_api.JaipurUpdatesService(baseUrl: ApiConfig.jaipurUpdatesBaseUrl);
    _loadUpdates();
    _updateTimer = Timer.periodic(const Duration(seconds: 15), (_) => _loadUpdates());
  }

  Future<void> _loadUpdates() async {
    final updates = await _service.fetchUpdates(city: 'Jaipur', limit: 5);
    if (!mounted) return;
    setState(() {
      _updates = updates;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _updates.isNotEmpty
        ? _updates
        : [jaipur_api.JaipurUpdate(city: 'Jaipur', title: 'City Update', description: 'No real updates yet')];
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('City: Jaipur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        autoPlay: true,
                      ),
                      items: items.map((u) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.indigo],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(u.city, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 6),
                                Text(u.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                                const SizedBox(height: 4),
                                Text(u.description, style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// JaipurUpdate model is defined in jaipur_updates_service.dart
