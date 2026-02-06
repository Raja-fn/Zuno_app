import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zuno/features/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gtveetggzpbmnzbkyrpz.supabase.co',
    anonKey: 'sb_publishable_giyZUW_SITPt_akwaK0KOQ_pJBeXXK5',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      // Global typography: Open Sans by Google Fonts (professional, clean)
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.openSansTextTheme(ThemeData.light().textTheme),
      ),
    );
  }
}
