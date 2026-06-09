class AppUser {
  final String id;
  final String name;
  final String email;
  final String campus;
  final String program;
  final String avatarUrl;
  final String bio;
  final int eventsCount;
  final int communitiesCount;
  final int connectionsCount;
  final List<String> joinedCommunityIds;
  final List<String> rsvpEventIds;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.campus,
    required this.program,
    required this.avatarUrl,
    required this.bio,
    this.eventsCount = 0,
    this.communitiesCount = 0,
    this.connectionsCount = 0,
    this.joinedCommunityIds = const [],
    this.rsvpEventIds = const [],
  });

  AppUser copyWith({
    String? name,
    String? bio,
    String? campus,
    String? program,
    List<String>? joinedCommunityIds,
    List<String>? rsvpEventIds,
    int? eventsCount,
    int? communitiesCount,
    int? connectionsCount,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      campus: campus ?? this.campus,
      program: program ?? this.program,
      avatarUrl: avatarUrl,
      bio: bio ?? this.bio,
      eventsCount: eventsCount ?? this.eventsCount,
      communitiesCount: communitiesCount ?? this.communitiesCount,
      connectionsCount: connectionsCount ?? this.connectionsCount,
      joinedCommunityIds: joinedCommunityIds ?? this.joinedCommunityIds,
      rsvpEventIds: rsvpEventIds ?? this.rsvpEventIds,
    );
  }
}
// container
//This is a placeholder for the user container which will handle state management and API interactions related to the AppUser model.