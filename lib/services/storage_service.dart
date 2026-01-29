import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  Future<String> uploadPostImage(File image) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('No user');

    final fileExt = image.path.split('.').last;
    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = fileName;

    await supabase.storage.from('posts').upload(
      filePath,
      image,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    final imageUrl = supabase.storage.from('posts').getPublicUrl(filePath);
    return imageUrl;
  }
}
