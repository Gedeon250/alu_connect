import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/events_provider.dart';
import '../../theme/app_theme.dart';
import '../../data/database_helper.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    final saved = await DatabaseHelper.isEventSaved(widget.eventId);
    if (mounted) setState(() => _isSaved = saved);
  }

  Future<void> _toggleSave(Event event) async {
    if (_isSaved) {
      await DatabaseHelper.unsaveEvent(event.id);
    } else {
      await DatabaseHelper.saveEvent(event);
    }
    if (mounted) setState(() => _isSaved = !_isSaved);
  }

  Color _typeColor(EventType type) {
    switch (type) {
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

  @override
  Widget build(BuildContext context) {
    final eventsProvider = context.watch<EventsProvider>();
    final event = eventsProvider.events.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => eventsProvider.events.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, event),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTags(event),
                  const SizedBox(height: 14),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOrganizerRow(event),
                  const SizedBox(height: 20),
                  _buildInfoCards(event),
                  const SizedBox(height: 20),
                  _buildAttendees(event),
                  const SizedBox(height: 20),
                  const Text(
                    'About the Event',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, event, eventsProvider),
    );
  }

  Widget _buildAppBar(BuildContext context, Event event) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.white),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => _toggleSave(event),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              size: 20,
              color: _isSaved ? AppColors.primary : Colors.white,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.share_outlined,
                size: 20, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          event.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surface,
            child: const Center(
                child: Icon(Icons.image_outlined,
                    color: AppColors.textMuted, size: 60)),
          ),
        ),
      ),
    );
  }

  Widget _buildTags(Event event) {
    return Wrap(
      spacing: 8,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _typeColor(event.type).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: _typeColor(event.type).withValues(alpha: 0.4)),
          ),
          child: Text(
            event.typeLabel.toUpperCase(),
            style: TextStyle(
              color: _typeColor(event.type),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ...event.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.tagEvent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11),
              ),
            )),
      ],
    );
  }

  Widget _buildOrganizerRow(Event event) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(event.organizerAvatarUrl),
          backgroundColor: AppColors.surface,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Organized by',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            Text(
              event.organizerName,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCards(Event event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          _infoRow(
            Icons.calendar_today_outlined,
            'Date & Time',
            DateFormat('EEEE, MMMM d, yyyy').format(event.dateTime),
            DateFormat('h:mm a').format(event.dateTime),
          ),
          const Divider(color: AppColors.divider, height: 20),
          _infoRow(
            Icons.location_on_outlined,
            'Location',
            event.location,
            event.campus,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      IconData icon, String label, String line1, String line2) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11)),
            Text(line1,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            Text(line2,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendees(Event event) {
    return Row(
      children: [
        _attendeeChip(Icons.check_circle_outline, '${event.goingCount}',
            'Going', AppColors.success),
        const SizedBox(width: 12),
        _attendeeChip(Icons.star_outline, '${event.interestedCount}',
            'Interested', AppColors.warning),
      ],
    );
  }

  Widget _attendeeChip(
      IconData icon, String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, Event event, EventsProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => provider.rsvp(event.id, RsvpStatus.going),
              style: ElevatedButton.styleFrom(
                backgroundColor: event.rsvpStatus == RsvpStatus.going
                    ? AppColors.success
                    : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: Icon(
                event.rsvpStatus == RsvpStatus.going
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                size: 18,
              ),
              label: Text(
                event.rsvpStatus == RsvpStatus.going ? 'Going ✓' : 'RSVP',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () =>
                  provider.rsvp(event.id, RsvpStatus.interested),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    event.rsvpStatus == RsvpStatus.interested
                        ? AppColors.warning
                        : AppColors.textSecondary,
                side: BorderSide(
                  color: event.rsvpStatus == RsvpStatus.interested
                      ? AppColors.warning
                      : AppColors.divider,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: Icon(
                event.rsvpStatus == RsvpStatus.interested
                    ? Icons.star
                    : Icons.star_outline,
                size: 18,
              ),
              label: const Text('Interested'),
            ),
          ),
        ],
      ),
    );
  }
}
