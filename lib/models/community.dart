class Community {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final int memberCount;
  final String leaderId;
  final String leaderName;
  final DateTime createdAt;
  bool isJoined;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.memberCount,
    required this.leaderId,
    required this.leaderName,
    required this.createdAt,
    this.isJoined = false,
  });
}
// container
//TODO: Implement community container for state management and API interactions.