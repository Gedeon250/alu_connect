import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/event_card.dart';
import '../../widgets/community_card.dart';

// Explore screen — Member 3 (Kenny) is responsible for the body content.
// Member 1 added: campus filter row (Kigali / Mauritius / All Campuses),
// which is an ALU-specific feature addressing the two-campus context.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  String _selectedCampus   = 'All Campuses';
  String _searchQuery      = '';

  final List<String> _categories = ['All', 'Events', 'Opportunities', 'Clubs'];

  // Campus options — ALU has exactly two campuses plus an all-campus view.
  // This filter is unique to ALU's intercampus context.
  final List<Map<String, String>> _campuses = [
    {'label': 'All Campuses', 'flag': '🌍'},
    {'label': 'Kigali Campus', 'flag': '🇷🇼'},
    {'label': 'Mauritius Campus', 'flag': '🇲🇺'},
  ];

  List<dynamic> get _filteredResults {
    if (_selectedCategory == 'Clubs') return mockCommunities;

    return mockEvents.where((e) {
      final matchesSearch = _searchQuery.isEmpty ||
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          e.category.toLowerCase() == _selectedCategory.toLowerCase();

      // Campus filter: 'All Campuses' shows everything;
      // campus-specific shows exact matches AND events marked 'All Campuses'
      final matchesCampus = _selectedCampus == 'All Campuses' ||
          e.campus == _selectedCampus ||
          e.campus == 'All Campuses';

      return matchesSearch && matchesCategory && matchesCampus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.md, 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Explore', style: AppTextStyles.displayMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ── Search bar ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: TextField(
                style: AppTextStyles.bodyLarge,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(
                  hintText: 'Search events, people, clubs...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                ),
              ),
            ),

            // ── Category chips ─────────────────────────────────────────────
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _categories.length,
                itemBuilder: (ctx, i) {
                  final cat        = _categories[i];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.gold,
                      backgroundColor: AppColors.surface,
                      checkmarkColor: AppColors.background,
                      labelStyle: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? AppColors.background
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Campus filter (ALU-specific) ──────────────────────────────
            // ALU has two campuses (Kigali + Mauritius). This filter lets
            // students see only what's relevant to their campus — a feature
            // that makes the app genuinely useful in the ALU context.
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _campuses.length,
                itemBuilder: (ctx, i) {
                  final campus     = _campuses[i];
                  final label      = campus['label']!;
                  final flag       = campus['flag']!;
                  final isSelected = label == _selectedCampus;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCampus = label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.gold.withValues(alpha: 0.15)
                              : AppColors.surfaceElevated,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.border,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(flag,
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              label.replaceAll(' Campus', ''),
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Results header ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
              child: Row(
                children: [
                  Text(
                    _selectedCategory == 'Clubs'
                        ? 'Communities'
                        : 'Recommended for you',
                    style: AppTextStyles.headingLarge,
                  ),
                  const Spacer(),
                  if (_selectedCampus != 'All Campuses')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        _selectedCampus.replaceAll(' Campus', ''),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.gold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Results list ───────────────────────────────────────────────
            Expanded(
              child: _selectedCategory == 'Clubs'
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg),
                      itemCount: mockCommunities.length,
                      itemBuilder: (ctx, i) =>
                          CommunityCard(community: mockCommunities[i]),
                    )
                  : results.isEmpty
                      ? _EmptyResult(
                          campus: _selectedCampus,
                          category: _selectedCategory,
                          query: _searchQuery,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg),
                          itemCount: results.length,
                          itemBuilder: (ctx, i) =>
                              EventCard(event: results[i] as dynamic),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state with contextual message ───────────────────────────────────────
class _EmptyResult extends StatelessWidget {
  final String campus;
  final String category;
  final String query;
  const _EmptyResult(
      {required this.campus, required this.category, required this.query});

  @override
  Widget build(BuildContext context) {
    final campusLabel =
        campus == 'All Campuses' ? '' : ' at ${campus.replaceAll(' Campus', '')}';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                color: AppColors.textMuted, size: 52),
            const SizedBox(height: AppSpacing.md),
            Text(
              query.isNotEmpty
                  ? 'No results for "$query"$campusLabel'
                  : 'No $category events$campusLabel right now',
              style: AppTextStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Try a different campus or category.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
