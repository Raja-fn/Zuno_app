import 'dart:convert';
import 'package:http/http.dart' as http;

class JaipurUpdatesService {
  final String baseUrl;
  JaipurUpdatesService({required this.baseUrl});

  Future<List<JaipurUpdate>> fetchUpdates({String city = 'Jaipur', int limit = 5}) async {
    final uri = Uri.parse('$baseUrl/updates?city=${Uri.encodeComponent(city)}&limit=$limit');
    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as List;
        return data.map((e) => JaipurUpdate.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

class JaipurUpdate {
  final String city;
  final String title;
  final String description;

  JaipurUpdate({required this.city, required this.title, required this.description});

  factory JaipurUpdate.fromJson(Map<String, dynamic> json) {
    return JaipurUpdate(
      city: json['city'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
