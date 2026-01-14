import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static bool _supabaseInitialized = false;

  /// Public accessor for tests and other services
  static bool get supabaseInitialized => _supabaseInitialized;

  /// Initializes Supabase if env variables are set. Safe to call multiple times.
  static Future<void> initSupabase() async {
    if (_supabaseInitialized) return;
    final url = dotenv.env['SUPABASE_URL'];
    final key = dotenv.env['SUPABASE_KEY'];
    if (url != null && key != null && url.isNotEmpty && key.isNotEmpty) {
      await Supabase.initialize(url: url, anonKey: key);
      _supabaseInitialized = true;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setGuestMode(bool guest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guestMode', guest);
  }

  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('guestMode') ?? false;
  }

  /// Sign in via Supabase - returns true if successful. This will fallback
  /// to returning false when Supabase is not configured.
  static Future<bool> signIn(String email, String password) async {
    try {
      await initSupabase();
      if (!_supabaseInitialized) return false;
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.session != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setBool('guestMode', false);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('guestMode', false);
    try {
      if (_supabaseInitialized) {
        await Supabase.instance.client.auth.signOut();
      }
    } catch (_) {}
  }
}