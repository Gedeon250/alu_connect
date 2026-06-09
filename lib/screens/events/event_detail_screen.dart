import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/event.dart';
import '../../theme/app_theme.dart';
import '../../widgets/tag_chip.dart';

// Event Detail + RSVP screen — Member 4 (Gift) is responsible for this.
// This starter version shows event info and RSVP buttons with state toggling.
class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isGoing      = false;
  bool _isInterested = false;
  int _goingCount    = 0;
  int _interestedCount = 0;

  @override
  void initState() {
    super.initState();
    _goingCount      = widget.event.goingCount;
    _interestedCount = widget.event.interestedCount;
    _loadRsvpState();
  }

  Future<void> _loadRsvpState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGoing      = prefs.getBool('rsvp_going_${widget.event.id}')      ?? false;
      _isInterested = prefs.getBool('rsvp_interested_${widget.event.id}') ?? false;
    });
  }

  Future<void> _toggleGoing() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGoing = !_isGoing;
      _goingCount += _isGoing ? 1 : -1;
      if (_isGoing) { _isInterested = false; }
    });
    await prefs.setBool('rsvp_going_${widget.event.id}', _isGoing);
    await prefs.setBool('rsvp_interested_${widget.event.id}', false);
  }

  Future<void> _toggleInterested() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isInterested = !_isInterested;
      _interestedCount += _isInterested ? 1 : -1;
      if (_isInterested) { _isGoing = false; }
    });
    await prefs.setBool('rsvp_interested_${widget.event.id}', _isInterested);
    await prefs.setBool('rsvp_going_${widget.event.id}', false);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surfaceElevated,
                child: const Icon(Icons.image_outlined, size: 72, color: AppColors.textMuted),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: event.tags.map((t) => TagChip(label: t)).toList(),
                  ),
                  const SizedBox(height: 12),

                  Text(event.title, style: AppTextStyles.displayMedium),
                  const SizedBox(height: 16),

                  _infoRow(Icons.calendar_today_outlined, event.date),
                  const SizedBox(height: 8),
                  _infoRow(Icons.access_time_outlined, event.time),
                  const SizedBox(height: 8),
                  _infoRow(Icons.location_on_outlined, event.location),
                  const SizedBox(height: 20),

                  Text(event.description, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 20),

                  // Attendee count — overlapping avatars use Stack+Positioned
                  // instead of negative margin (Flutter asserts margin >= 0).
                  Row(
                    children: [
                      SizedBox(
                        width: 56, // 30 + 13 + 13 (two 13px overlaps)
                        height: 30,
                        child: Stack(
                          children: [
                            for (int i = 0; i < 3; i++)
                              Positioned(
                                left: i * 13.0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.gold
                                        .withValues(alpha: 0.3 + i * 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.background, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '$_goingCount going  •  $_interestedCount interested',
                        style: AppTextStyles.labelMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // RSVP buttons
                  ElevatedButton(
                    onPressed: _toggleGoing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isGoing ? AppColors.gold : AppColors.gold.withValues(alpha: 0.85),
                    ),
                    child: Text(_isGoing ? 'Going ✓' : 'RSVP'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _toggleInterested,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isInterested ? AppColors.gold : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      _isInterested ? 'Interested ✓' : 'Interested',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: _isInterested ? AppColors.gold : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.gold),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
      ],
    );
  }
}
