import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<User?> signIn(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Invalid credentials');
    }

    // Return the user so we can check email verification
    return response.user;
  }

  Future<void> signUp(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign up failed');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> resendVerificationEmail(String email) async {
    await supabase.auth.resend(type: OtpType.signup, email: email);
  }

  bool get isLoggedIn => supabase.auth.currentUser != null;

  bool get isEmailVerified {
    final user = supabase.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }
}
