import 'package:shared_preferences/shared_preferences.dart';

// AuthService wraps all SharedPreferences calls related to authentication
// and the user's profile. All screens should use this instead of calling
// SharedPreferences directly for auth-related data.
//
// For non-auth persistence (RSVP state, community joins) use
// SharedPreferences directly in the relevant widget.
class AuthService {
  AuthService._();

  // ── Keys (private — only this class touches them) ─────────────────────────
  static const _kLoggedIn   = 'isLoggedIn';
  static const _kName       = 'userName';
  static const _kEmail      = 'userEmail';
  static const _kCampus     = 'userCampus';
  static const _kInterests  = 'userInterests';

  // ── Login / logout ─────────────────────────────────────────────────────────

  static Future<void> login({
    required String name,
    required String email,
    required String campus,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kName,   name);
    await prefs.setString(_kEmail,  email);
    await prefs.setString(_kCampus, campus);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  // ── User profile ───────────────────────────────────────────────────────────

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name':   prefs.getString(_kName)   ?? 'Student',
      'email':  prefs.getString(_kEmail)  ?? '',
      'campus': prefs.getString(_kCampus) ?? 'Kigali Campus',
    };
  }

  // ── Interests (personalised feed) ─────────────────────────────────────────

  static Future<void> saveInterests(List<String> interests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kInterests, interests);
  }

  static Future<List<String>> getInterests() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kInterests) ?? [];
  }

  // ── Helper — derives display name from email ───────────────────────────────
  // e.g. "john.doe@alustudent.com" → "John Doe"
  static String nameFromEmail(String email) {
    final part = email.split('@').first;
    return part
        .split('.')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}
