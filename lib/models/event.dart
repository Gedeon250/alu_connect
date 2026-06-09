class Event {
  final String       id;
  final String       title;
  final String       description;
  final String       category;
  final String       date;
  final String       time;
  final String       location;
  final String       campus;      // 'Kigali Campus' | 'Mauritius Campus' | 'All Campuses'
  final String       imageUrl;
  final List<String> tags;
  final int          goingCount;
  final int          interestedCount;
  final bool         isFeatured;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.campus,
    required this.imageUrl,
    required this.tags,
    required this.goingCount,
    required this.interestedCount,
    this.isFeatured = false,
  });
}
