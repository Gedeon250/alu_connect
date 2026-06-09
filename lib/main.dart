import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/interests_screen.dart';
import 'screens/shell/main_shell.dart';
import 'screens/home/create_post_screen.dart';
import 'screens/explore/communities_screen.dart';
import 'screens/events/event_detail_screen.dart';
import 'screens/events/my_rsvps_screen.dart';
import 'models/event.dart';

void main() {
  runApp(const AluConnectApp());
}

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }
}

// ── Route generation ───────────────────────────────────────────────────────────
Route<dynamic>? _generateRoute(RouteSettings settings) {
  switch (settings.name) {

    // ── Auth routes (always active) ──────────────────────────────────────────
    case '/':
      return _fadeRoute(const SplashScreen());
    case '/login':
      return _slideRoute(const LoginScreen());
    case '/signup':
      return _slideRoute(const SignUpScreen());
    case '/interests':
      return _slideRoute(const InterestsScreen());

    // ── Main app shell ────────────────────────────────────────────────────────
    case '/home':
      return _fadeRoute(const MainShell());

    // ── Tab deep-links (jump directly to a specific tab) ─────────────────────
    case '/explore':
      return _fadeRoute(const MainShell(initialIndex: 1));
    case '/chats':
      return _fadeRoute(const MainShell(initialIndex: 2));
    case '/profile':
      return _fadeRoute(const MainShell(initialIndex: 3));

    // ── Routes to uncomment as each member finishes their screen ─────────────
    case '/create-post':
      return _slideUpRoute(const CreatePostScreen());
    case '/communities':
      return _slideRoute(const CommunitiesScreen());
    case '/event-detail':
      final event = settings.arguments as Event;
      return _slideRoute(EventDetailScreen(event: event));
    case '/my-rsvps':
      return _slideRoute(const MyRsvpsScreen());

    default:
      return _fadeRoute(const SplashScreen());
  }
}

// ── Transition helpers ─────────────────────────────────────────────────────────

// Slide from right with fade — forward navigation / drill-down
PageRouteBuilder<dynamic> _slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.1, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: anim, child: child),
    ),
    transitionDuration: const Duration(milliseconds: 280),
  );
}

// Slide up from bottom — modal / create-post screens
PageRouteBuilder<dynamic> _slideUpRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionsBuilder: (_, anim, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: anim, child: child),
    ),
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// Fade only — top-level tab switches
PageRouteBuilder<dynamic> _fadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 220),
  );
}
