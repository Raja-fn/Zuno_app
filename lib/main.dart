import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'features/auth/auth_gate.dart';
import 'features/clips/clips_screen.dart';
import 'features/community/community_screen.dart';
import 'features/navigation/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const ZunoApp());
}

class ZunoApp extends StatelessWidget {
  const ZunoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
        routes: {
          '/community': (context) => const CommunityScreen(
          ),
        },
    );
  }
}
Future<bool> hasProfile(String userId) async {
  final res = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('id', userId)
      .maybeSingle();

  return res != null;
}

