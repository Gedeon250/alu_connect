import 'package:flutter/material.dart';

class Community {
  final String id;
  final String name;
  final String description;
  final int    memberCount;
  final String category;   // e.g. 'Tech', 'Leadership', 'Arts'
  final Color  iconColor;  // background color for the community avatar
  final String iconEmoji;  // emoji displayed inside the avatar
  bool         isJoined;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.category,
    required this.iconColor,
    required this.iconEmoji,
    this.isJoined = false,
  });
}
