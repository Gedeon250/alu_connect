import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/event.dart';
import '../../widgets/event_card.dart';

// My RSVPs screen — shows events the user actually marked Going or Interested.
// Loads RSVP state from SharedPreferences (same keys set in event_detail_screen).
class MyRsvpsScreen extends StatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Event> _goingEvents      = [];
  List<Event> _interestedEvents = [];
  bool        _isLoading        = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRsvps();
  }

  // Read every event's RSVP flags from SharedPreferences and separate
  // them into Going and Interested lists.
  Future<void> _loadRsvps() async {
    final prefs = await SharedPreferences.getInstance();

    final going = mockEvents
        .where((e) => prefs.getBool('rsvp_going_${e.id}') == true)
        .toList();
    final interested = mockEvents
        .where((e) => prefs.getBool('rsvp_interested_${e.id}') == true)
        .toList();

    if (!mounted) return;
    setState(() {
      _goingEvents      = going;
      _interestedEvents = interested;
      _isLoading        = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My RSVPs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.gold,
          dividerColor: AppColors.border,
          tabs: [
            Tab(text: 'Going (${_goingEvents.length})'),
            Tab(text: 'Interested (${_interestedEvents.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : TabBarView(
              controller: _tabController,
              children: [
                _RsvpList(
                  events: _goingEvents,
                  emptyIcon: Icons.event_available_outlined,
                  emptyMessage: 'You haven\'t RSVP\'d to any events yet.',
                  emptyHint: 'Browse events and tap RSVP to register.',
                ),
                _RsvpList(
                  events: _interestedEvents,
                  emptyIcon: Icons.bookmark_outline,
                  emptyMessage: 'Nothing marked as Interested yet.',
                  emptyHint: 'Tap "Interested" on any event to save it here.',
                ),
              ],
            ),
    );
  }
}

// ── List with proper empty state ───────────────────────────────────────────────
class _RsvpList extends StatelessWidget {
  final List<Event> events;
  final IconData    emptyIcon;
  final String      emptyMessage;
  final String      emptyHint;

  const _RsvpList({
    required this.events,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.emptyHint,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(emptyIcon, color: AppColors.textMuted, size: 56),
              const SizedBox(height: AppSpacing.md),
              Text(
                emptyMessage,
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                emptyHint,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: events.length,
      itemBuilder: (ctx, i) => EventCard(event: events[i]),
    );
  }
}
