import 'dart:io';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadService {
  final _client = Supabase.instance.client;

  Future<String> uploadPostImage(File imageFile) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';

    await _client.storage
        .from('post-images')
        .upload(fileName, imageFile);

    return _client.storage
        .from('post-images')
        .getPublicUrl(fileName);
  }
}
