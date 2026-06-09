import 'package:flutter/material.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';
import 'tag_chip.dart';

// EventCard is used in both the Home feed and Explore screen.
// Pass isFeatured: true to get the larger hero-style card.
class EventCard extends StatelessWidget {
  final Event  event;
  final bool   isFeatured;

  const EventCard({super.key, required this.event, this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/event-detail', arguments: event),
      child: isFeatured ? _FeaturedCard(event: event) : _CompactCard(event: event),
    );
  }
}

// ── Large featured card ────────────────────────────────────────────────────────
// Fixed height removed — card is intrinsic so content never overflows.
// Description and button removed: the card is fully tappable, and detail
// info lives on the event detail screen. Keeping the card scannable.
class _FeaturedCard extends StatelessWidget {
  final Event event;
  const _FeaturedCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceElevated, Color(0xFF1F2340)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TagChip(label: event.category, isSmall: true),
            const SizedBox(height: AppSpacing.sm),
            Text(
              event.title,
              style: AppTextStyles.headingLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${event.date} • ${event.location}',
              style: AppTextStyles.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              event.description,
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${event.goingCount} going  •  ${event.interestedCount} interested',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Compact list card ──────────────────────────────────────────────────────────
class _CompactCard extends StatelessWidget {
  final Event event;
  const _CompactCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Thumbnail placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.event, color: AppColors.gold, size: 28),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: AppTextStyles.headingMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('${event.date} • ${event.location}',
                    style: AppTextStyles.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),

          const SizedBox(width: 8),
          TagChip(label: event.category, isSmall: true),
        ],
      ),
    );
  }
}
