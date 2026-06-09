enum EventType { event, opportunity, hackathon, workshop, internship, community }

enum RsvpStatus { none, going, interested }

class Event {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final DateTime dateTime;
  final String location;
  final String campus;
  final String organizerName;
  final String organizerId;
  final String organizerAvatarUrl;
  final String imageUrl;
  final List<String> tags;
  final int goingCount;
  final int interestedCount;
  final bool isFeatured;
  final DateTime createdAt;
  RsvpStatus rsvpStatus;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dateTime,
    required this.location,
    required this.campus,
    required this.organizerName,
    required this.organizerId,
    required this.organizerAvatarUrl,
    required this.imageUrl,
    required this.tags,
    this.goingCount = 0,
    this.interestedCount = 0,
    this.isFeatured = false,
    required this.createdAt,
    this.rsvpStatus = RsvpStatus.none,
  });

  String get typeLabel {
    switch (type) {
      case EventType.event:
        return 'Event';
      case EventType.opportunity:
        return 'Opportunity';
      case EventType.hackathon:
        return 'Hackathon';
      case EventType.workshop:
        return 'Workshop';
      case EventType.internship:
        return 'Internship';
      case EventType.community:
        return 'Community';
    }
  }

  Event copyWith({RsvpStatus? rsvpStatus, int? goingCount, int? interestedCount}) {
    return Event(
      id: id,
      title: title,
      description: description,
      type: type,
      dateTime: dateTime,
      location: location,
      campus: campus,
      organizerName: organizerName,
      organizerId: organizerId,
      organizerAvatarUrl: organizerAvatarUrl,
      imageUrl: imageUrl,
      tags: tags,
      goingCount: goingCount ?? this.goingCount,
      interestedCount: interestedCount ?? this.interestedCount,
      isFeatured: isFeatured,
      createdAt: createdAt,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
    );
  }
}
