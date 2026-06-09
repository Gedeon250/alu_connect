import 'package:flutter/material.dart';
import '../models/community.dart';
import '../data/mock_data.dart';

class CommunitiesProvider extends ChangeNotifier {
  List<Community> _communities = List.from(MockData.communities);

  List<Community> get allCommunities => _communities;

  // Only communities the user has joined
  List<Community> get myCommunities {
    List<Community> result = [];
    for (Community c in _communities) {
      if (c.isJoined) {
        result.add(c);
      }
    }
    return result;
  }

  // Search communities by name or category
  List<Community> search(String query) {
    if (query.isEmpty) {
      return _communities;
    }

    String q = query.toLowerCase();
    List<Community> result = [];

    for (Community c in _communities) {
      if (c.name.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q)) {
        result.add(c);
      }
    }
    return result;
  }

  // Join or leave a community
  void toggleJoin(String communityId) {
    for (int i = 0; i < _communities.length; i++) {
      if (_communities[i].id == communityId) {
        _communities[i].isJoined = !_communities[i].isJoined;
        break;
      }
    }
    notifyListeners();
  }
}
