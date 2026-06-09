import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../data/mock_data.dart';
import '../../models/event.dart';
import '../../widgets/event_card.dart';

// Home feed screen — Member 2 owns the body content.
// Member 1 (Gedeon) owns: dynamic username, working category filter,
// Campus Pulse strip, and the "For You" section driven by interests.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName       = '';
  String _campus         = '';
  String _selectedFilter = 'All';
  List<String> _userInterests = [];

  final List<String> _filters = [
    'All', 'Events', 'Opportunities', 'Clubs', 'Academics',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData  = await AuthService.getUserData();
    final interests = await AuthService.getInterests();
    if (!mounted) return;
    setState(() {
      _userName      = userData['name']   ?? 'Student';
      _campus        = userData['campus'] ?? '';
      _userInterests = interests;
    });
  }

  // Returns the first name only (e.g. "Aline Umuhoza" → "Aline")
  String get _firstName {
    final parts = _userName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : _userName;
  }

  // Events filtered by the selected category chip
  List<Event> get _filteredEvents {
    if (_selectedFilter == 'All') return mockEvents.where((e) => !e.isFeatured).take(5).toList();
    return mockEvents
        .where((e) => !e.isFeatured &&
            e.category.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  // "For You" events — those matching any of the user's selected interests
  List<Event> get _forYouEvents {
    if (_userInterests.isEmpty) return [];
    return mockEvents.where((e) {
      return e.tags.any((tag) => _userInterests.any(
          (interest) => interest.toLowerCase().contains(tag.toLowerCase()) ||
              tag.toLowerCase().contains(interest.toLowerCase())));
    }).take(3).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final featured    = mockEvents.where((e) => e.isFeatured).toList();
    final forYou      = _forYouEvents;
    final latest      = _filteredEvents;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Greeting + avatar ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Reads real name from SharedPreferences
                          Text(
                            'Hi, $_firstName! 👋',
                            style: AppTextStyles.displayMedium,
                          ),
                          Text(
                            _campus.isEmpty
                                ? 'What\'s happening today?'
                                : '$_campus · What\'s happening?',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.gold,
                        child: Text(
                          _firstName.isNotEmpty ? _firstName[0].toUpperCase() : 'A',
                          style: AppTextStyles.headingLarge
                              .copyWith(color: AppColors.background),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Campus Pulse strip ────────────────────────────────────────
            // Unique feature: a live snapshot of campus activity.
            // Shows students at a glance how active their campus is —
            // designed specifically for ALU's two-campus intercampus dynamic.
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _PulseStat(icon: '📅', value: '6', label: 'This week'),
                      _dividerDot(),
                      _PulseStat(icon: '👥', value: '245', label: 'Students active'),
                      _dividerDot(),
                      _PulseStat(icon: '🏛️', value: '12', label: 'Clubs active'),
                    ],
                  ),
                ),
              ),
            ),

            // ── Search bar ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: AppTextStyles.bodyLarge,
                  onTap: () => Navigator.pushNamed(context, '/explore'),
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Search opportunities, events, people...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Category filter chips (actually work!) ────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filters.length,
                  itemBuilder: (ctx, i) {
                    final label      = _filters[i];
                    final isSelected = label == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        selectedColor: AppColors.gold,
                        backgroundColor: AppColors.surface,
                        labelStyle: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedFilter = label),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── "For You" section (personalised by interests) ─────────────
            // Only shown when user completed interests onboarding.
            // This is a unique feature — the sample has no personalisation.
            if (forYou.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Text('For You', style: AppTextStyles.headingLarge),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _userInterests.take(2).join(' · '),
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.gold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: EventCard(event: forYou[i]),
                  ),
                  childCount: forYou.length,
                ),
              ),
            ],

            // ── Featured section ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Featured', style: AppTextStyles.headingLarge),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/explore'),
                      child: Text(
                        'See all',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.gold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (featured.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: EventCard(event: featured.first, isFeatured: true),
                ),
              ),

            // ── Latest section (filtered by chip selection) ───────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  _selectedFilter == 'All'
                      ? 'Latest Opportunities'
                      : _selectedFilter,
                  style: AppTextStyles.headingLarge,
                ),
              ),
            ),

            // Empty state when filter has no results
            if (latest.isEmpty)
              SliverToBoxAdapter(
                child: _EmptyState(
                  icon: Icons.search_off_rounded,
                  message: 'No $_selectedFilter events right now.',
                  hint: 'Check back soon or explore other categories.',
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: EventCard(event: latest[i]),
                  ),
                  childCount: latest.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _dividerDot() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.border,
          shape: BoxShape.circle,
        ),
      );
}

// ── Campus Pulse stat item ─────────────────────────────────────────────────────
class _PulseStat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  const _PulseStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(label, style: AppTextStyles.labelMedium.copyWith(fontSize: 10)),
      ],
    );
  }
}

// ── Reusable empty state widget ────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String   message;
  final String   hint;
  const _EmptyState({required this.icon, required this.message, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 48),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.headingMedium, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(hint,
              style: AppTextStyles.labelMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
