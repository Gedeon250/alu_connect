import 'package:flutter/material.dart';
import '../models/event.dart';
import '../data/mock_data.dart';

class EventsProvider extends ChangeNotifier {
  List<Event> _events = List.from(MockData.events);
  bool _isLoading = false;
  String _filterType = 'All';

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String get filterType => _filterType;

  // Only featured events
  List<Event> get featuredEvents {
    List<Event> result = [];
    for (Event e in _events) {
      if (e.isFeatured) {
        result.add(e);
      }
    }
    return result;
  }

  // Events filtered by the selected category
  List<Event> get filteredEvents {
    if (_filterType == 'All') {
      return _events;
    }

    List<Event> result = [];
    for (Event e in _events) {
      if (_filterType == 'Events' && e.type == EventType.event) {
        result.add(e);
      } else if (_filterType == 'Opportunities' &&
          (e.type == EventType.opportunity || e.type == EventType.internship)) {
        result.add(e);
      } else if (_filterType == 'Hackathons' && e.type == EventType.hackathon) {
        result.add(e);
      } else if (_filterType == 'Workshops' && e.type == EventType.workshop) {
        result.add(e);
      } else if (_filterType == 'Community' && e.type == EventType.community) {
        result.add(e);
      }
    }
    return result;
  }

  // All events the user has RSVP'd to
  List<Event> get myRsvps {
    List<Event> result = [];
    for (Event e in _events) {
      if (e.rsvpStatus != RsvpStatus.none) {
        result.add(e);
      }
    }
    return result;
  }

  List<Event> get goingEvents {
    List<Event> result = [];
    for (Event e in _events) {
      if (e.rsvpStatus == RsvpStatus.going) {
        result.add(e);
      }
    }
    return result;
  }

  List<Event> get interestedEvents {
    List<Event> result = [];
    for (Event e in _events) {
      if (e.rsvpStatus == RsvpStatus.interested) {
        result.add(e);
      }
    }
    return result;
  }

  void setFilter(String type) {
    _filterType = type;
    notifyListeners();
  }

  // Search events by title, description, or campus
  List<Event> search(String query) {
    if (query.isEmpty) {
      return filteredEvents;
    }

    String q = query.toLowerCase();
    List<Event> result = [];

    for (Event e in _events) {
      bool matchesTitle = e.title.toLowerCase().contains(q);
      bool matchesDesc = e.description.toLowerCase().contains(q);
      bool matchesCampus = e.campus.toLowerCase().contains(q);
      bool matchesOrganizer = e.organizerName.toLowerCase().contains(q);

      if (matchesTitle || matchesDesc || matchesCampus || matchesOrganizer) {
        result.add(e);
      }
    }
    return result;
  }

  // RSVP to an event (toggle going / interested)
  void rsvp(String eventId, RsvpStatus status) {
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].id == eventId) {
        Event event = _events[i];

        int going = event.goingCount;
        int interested = event.interestedCount;

        // Remove previous status count
        if (event.rsvpStatus == RsvpStatus.going) going--;
        if (event.rsvpStatus == RsvpStatus.interested) interested--;

        // Toggle off if same, otherwise set new status
        RsvpStatus newStatus = RsvpStatus.none;
        if (event.rsvpStatus != status) {
          newStatus = status;
        }

        // Add new status count
        if (newStatus == RsvpStatus.going) going++;
        if (newStatus == RsvpStatus.interested) interested++;

        _events[i] = event.copyWith(
          rsvpStatus: newStatus,
          goingCount: going,
          interestedCount: interested,
        );
        break;
      }
    }
    notifyListeners();
  }

  void addEvent(Event event) {
    _events.insert(0, event);
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false;
    notifyListeners();
  }
}
