import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      if (result.user == null) {
        return "Signup failed. No user returned.";
      }

      return null; // success
    } catch (e) {
      if (kDebugMode) {
        print("SignUp error: $e");
      }
      return "Signup failed: ${e.toString()}";
    }
  }

  // Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (result.user == null) {
        return "Login failed. User not found.";
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("SignIn error: $e");
      }
      return "Login failed: ${e.toString()}";
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("SignOut error: $e");
      }
    }
  }

  // Fetch user profile by email (e.g., for avatar preview)
  Future<Map<String, dynamic>?> getUserProfileByEmail(String email) async {
    final response = await _client
        .from('profiles') // <-- Corrected table name
        .select()
        .eq('email', email.trim())
        .maybeSingle();
    return response;
  }
}
