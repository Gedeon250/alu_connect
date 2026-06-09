import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Small colored label chip used on event cards and event detail pages.
class TagChip extends StatelessWidget {
  final String label;
  final bool   isSmall;

  const TagChip({super.key, required this.label, this.isSmall = false});

  Color _bgColor() {
    switch (label.toLowerCase()) {
      case 'event':       return AppColors.tagEvent.withValues(alpha: 0.25);
      case 'workshop':    return AppColors.tagOpportunity.withValues(alpha: 0.25);
      case 'competition': return AppColors.tagCompetition.withValues(alpha: 0.25);
      case 'opportunity': return AppColors.gold.withValues(alpha: 0.20);
      case 'startup':     return AppColors.gold.withValues(alpha: 0.20);
      case 'tech':        return AppColors.tagEvent.withValues(alpha: 0.25);
      case 'community':   return AppColors.tagOpportunity.withValues(alpha: 0.25);
      default:            return AppColors.surfaceElevated;
    }
  }

  Color _textColor() {
    switch (label.toLowerCase()) {
      case 'event':       return Colors.lightBlue;
      case 'workshop':    return Colors.greenAccent;
      case 'competition': return Colors.orange;
      case 'opportunity': return AppColors.gold;
      case 'startup':     return AppColors.gold;
      case 'tech':        return Colors.lightBlue;
      case 'community':   return Colors.greenAccent;
      default:            return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical:   isSmall ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.w600,
          color: _textColor(),
        ),
      ),
    );
  }
}
