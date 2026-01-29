import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://gtveetggzpbmnzbkyrpz.supabase.co',
      anonKey: 'sb_publishable_giyZUW_SITPt_akwaK0KOQ_pJBeXXK5',
    );
  }
}

