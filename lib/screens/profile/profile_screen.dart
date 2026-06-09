import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../data/mock_data.dart';

// Profile screen — Member 5 (Dorian) is responsible for this.
// Stats (Events RSVPd, Communities joined) are loaded from SharedPreferences
// so they reflect the user's real activity in the app.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name   = 'ALU Student';
  String _campus = 'Kigali Campus';
  String _email  = '';
  int    _eventsCount      = 0;
  int    _communitiesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data  = await AuthService.getUserData();
    final prefs = await SharedPreferences.getInstance();

    // Count events the user RSVPd for (going OR interested)
    int events = 0;
    for (final e in mockEvents) {
      if (prefs.getBool('rsvp_going_${e.id}') == true ||
          prefs.getBool('rsvp_interested_${e.id}') == true) {
        events++;
      }
    }

    // Count communities the user joined
    int communities = 0;
    for (final c in mockCommunities) {
      if (prefs.getBool('community_joined_${c.id}') == true) {
        communities++;
      }
    }

    if (!mounted) return;
    setState(() {
      _name            = data['name']   ?? 'ALU Student';
      _campus          = data['campus'] ?? 'Kigali Campus';
      _email           = data['email']  ?? '';
      _eventsCount      = events;
      _communitiesCount = communities;
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile', style: AppTextStyles.displayMedium),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Avatar ────────────────────────────────────────────────────
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.gold,
                child: Text(
                  _name.isNotEmpty ? _name[0].toUpperCase() : 'A',
                  style: AppTextStyles.displayLarge.copyWith(color: AppColors.background, fontSize: 40),
                ),
              ),
              const SizedBox(height: 12),

              Text(_name, style: AppTextStyles.headingLarge),
              const SizedBox(height: 4),
              Text(_campus, style: AppTextStyles.bodyMedium),
              if (_email.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(_email, style: AppTextStyles.labelMedium),
              ],

              const SizedBox(height: 24),

              // ── Stats row ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(label: 'Events',       count: _eventsCount),
                  _StatItem(label: 'Communities',  count: _communitiesCount),
                  _StatItem(label: 'Connections',  count: 87),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(color: AppColors.border),

              // ── Menu items ────────────────────────────────────────────────
              _MenuItem(icon: Icons.article_outlined,        title: 'My Posts'),
              _MenuItem(icon: Icons.bookmark_outline,        title: 'Saved'),
              _MenuItem(icon: Icons.notifications_outlined,  title: 'Notifications'),
              _MenuItem(icon: Icons.manage_accounts_outlined,title: 'Account Settings'),
              _MenuItem(icon: Icons.help_outline,            title: 'Help & Support'),

              const Divider(color: AppColors.border),

              // ── Logout ────────────────────────────────────────────────────
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: Text('Sign Out', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                onTap: _logout,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int    count;
  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: AppTextStyles.displayMedium),
        Text(label, style: AppTextStyles.labelMedium),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String   title;
  const _MenuItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
      onTap: () {},
    );
  }
}
