import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static SupabaseClient? _supabaseClient;

  static SupabaseClient get supabase {
    if (_supabaseClient == null) {
      throw Exception('Supabase not initialized. Call initSupabase first.');
    }
    return _supabaseClient!;
  }

  static bool get isSupabaseConfigured {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_KEY'];
    return supabaseUrl != null && 
           supabaseKey != null && 
           supabaseUrl.isNotEmpty && 
           supabaseKey.isNotEmpty;
  }

  static Future<void> initSupabase() async {
    if (!isSupabaseConfigured) {
      print('Supabase not configured. Skipping initialization.');
      return;
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final supabaseKey = dotenv.env['SUPABASE_KEY']!;

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      
      _supabaseClient = Supabase.instance.client;
      print('Supabase initialized successfully');
    } catch (e) {
      print('Error initializing Supabase: $e');
    }
  }

  // Placeholder methods for authentication
  static Future<bool> signIn(String email, String password) async {
    if (!isSupabaseConfigured) return false;
    
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  static Future<bool> signUp(String email, String password) async {
    if (!isSupabaseConfigured) return false;
    
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  static Future<void> signOut() async {
    if (!isSupabaseConfigured) return;
    
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  static String? getCurrentUserId() {
    if (!isSupabaseConfigured) return null;
    
    try {
      return supabase.auth.currentUser?.id;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }
}