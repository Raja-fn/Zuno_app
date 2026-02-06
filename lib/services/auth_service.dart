import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // LOGIN
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // SIGNUP (Instagram style)
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    // 1️⃣ Create auth user
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception("Signup failed");
    }

    // 2️⃣ Create profile row
    await _supabase.from('profiles').insert({
      'id': user.id,
      'username': username.toLowerCase(),
    });
  }

  // Password reset
  Future<void> resetPasswordForEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Optional: sign in with provider (Google/Facebook)
  Future<void> signInWithProvider(dynamic provider) async {
    final dynamic auth = _supabase.auth;
    await auth.signInWithProvider(provider);
  }
}
