import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final bool compact;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.compact = false,
  });

  Color get _typeColor {
    switch (event.type) {
      case EventType.hackathon:
        return AppColors.error;
      case EventType.workshop:
        return AppColors.accent;
      case EventType.opportunity:
      case EventType.internship:
        return AppColors.success;
      case EventType.community:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  Color get _tagBg {
    switch (event.type) {
      case EventType.hackathon:
        return AppColors.tagHackathon;
      case EventType.workshop:
        return AppColors.tagWorkshop;
      case EventType.opportunity:
      case EventType.internship:
        return AppColors.tagOpportunity;
      default:
        return AppColors.tagEvent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: compact ? 10 : 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTagRow(),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 7),
                  _buildMeta(),
                  const SizedBox(height: 10),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: Image.network(
        event.imageUrl,
        height: compact ? 130 : 170,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: compact ? 130 : 170,
          color: AppColors.surface,
          child: const Center(
            child: Icon(Icons.image_outlined,
                color: AppColors.textMuted, size: 40),
          ),
        ),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            height: compact ? 130 : 170,
            color: AppColors.surface,
            child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.primary)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTagRow() {
    return Wrap(
      spacing: 6,
      children: [
        _tag(event.typeLabel.toUpperCase(), _typeColor, _tagBg),
        ...event.tags.take(1).map(
              (tag) => _tag(tag, AppColors.textSecondary, AppColors.tagEvent),
            ),
      ],
    );
  }

  Widget _tag(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildMeta() {
    return Column(
      children: [
        _metaRow(
          Icons.calendar_today_outlined,
          DateFormat('MMM d, yyyy • h:mm a').format(event.dateTime),
        ),
        const SizedBox(height: 3),
        _metaRow(
          Icons.location_on_outlined,
          '${event.location} · ${event.campus}',
        ),
      ],
    );
  }

  Widget _metaRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.people_outline,
                size: 13, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              '${event.goingCount} going',
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        if (event.rsvpStatus != RsvpStatus.none)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: event.rsvpStatus == RsvpStatus.going
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event.rsvpStatus == RsvpStatus.going
                  ? '✓ Going'
                  : '★ Interested',
              style: TextStyle(
                color: event.rsvpStatus == RsvpStatus.going
                    ? AppColors.success
                    : AppColors.warning,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class FeaturedEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const FeaturedEventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 270,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                event.imageUrl,
                height: 190,
                width: 270,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 190,
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(Icons.image_outlined,
                        color: AppColors.textMuted, size: 40),
                  ),
                ),
              ),
              Container(
                height: 190,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.4, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xF0000000),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 11, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(event.dateTime),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.location_on_outlined,
                            size: 11, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.campus,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
