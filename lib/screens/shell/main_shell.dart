import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../chats/chats_screen.dart';
import '../profile/profile_screen.dart';

// MainShell — the root scaffold that wraps all 4 main tabs.
//
// Tab order (matching the spec):
//   Index 0 = Home
//   Index 1 = Explore
//   FAB     = Create Post  (opens /create-post as a new screen)
//   Index 2 = Chats
//   Index 3 = Profile
//
// Uses IndexedStack so each tab keeps its scroll position when you switch.
// The FAB sits between Explore and Chats in the bottom bar using a
// BottomAppBar with a centre notch.
class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  // The 4 real screens — FAB does NOT get an index
  static const List<Widget> _screens = [
    HomeScreen(),    // 0
    ExploreScreen(), // 1
    ChatsScreen(),   // 2
    ProfileScreen(), // 3
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Gold FAB in the centre notch
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-post'),
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.background,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BottomAppBar with a centre notch that hosts the FAB
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        elevation: 8,
        notchMargin: 6,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                selected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),

              // Explore
              _NavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explore',
                selected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),

              // Empty space for the FAB notch
              const SizedBox(width: 56),

              // Chats
              _NavItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Chats',
                selected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),

              // Profile
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                selected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single navigation item ────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String   label;
  final bool     selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? AppColors.gold : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? AppColors.gold : AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
