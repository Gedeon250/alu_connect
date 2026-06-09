import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/community.dart';
import '../theme/app_theme.dart';

// Reusable community card with a join/leave toggle.
// Join state is persisted to SharedPreferences so it survives app restarts.
class CommunityCard extends StatefulWidget {
  final Community community;
  const CommunityCard({super.key, required this.community});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  late bool _isJoined;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.community.isJoined; // initial value from mock data
    _loadJoinState();                       // then override with persisted value
  }

  Future<void> _loadJoinState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('community_joined_${widget.community.id}');
    if (saved != null && mounted) {
      setState(() => _isJoined = saved);
    }
  }

  Future<void> _toggleJoin() async {
    final newState = !_isJoined;
    setState(() => _isJoined = newState);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('community_joined_${widget.community.id}', newState);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newState
              ? 'Joined ${widget.community.name}!'
              : 'Left ${widget.community.name}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.community;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Icon
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceElevated,
            child: Text(c.iconEmoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),

          // Name + member count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: AppTextStyles.headingMedium),
                const SizedBox(height: 3),
                Text(
                  '${c.memberCount} members',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
          ),

          // Join / Joined button
          GestureDetector(
            onTap: _toggleJoin,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: _isJoined ? AppColors.surfaceElevated : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isJoined ? AppColors.border : AppColors.gold,
                  width: 1.5,
                ),
              ),
              child: Text(
                _isJoined ? 'Joined' : 'Join',
                style: AppTextStyles.labelMedium.copyWith(
                  color:
                      _isJoined ? AppColors.textSecondary : AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
