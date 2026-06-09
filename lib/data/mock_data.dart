import '../models/event.dart';
import '../models/community.dart';
import '../models/message.dart';
import '../models/user.dart';

class MockData {
  static final AppUser currentUser = AppUser(
    id: 'user_001',
    name: 'Jean Nishimwe',
    email: 'j.nishimwe@alustudent.com',
    campus: 'Kigali Campus',
    program: 'Software Engineering',
    avatarUrl:
        'https://ui-avatars.com/api/?name=Jean+Nishimwe&background=F5A623&color=000&size=128',
    bio:
        'Software Engineering student at ALU. Passionate about building products that solve real African challenges.',
    eventsCount: 23,
    communitiesCount: 5,
    connectionsCount: 87,
    joinedCommunityIds: ['comm_001', 'comm_003', 'comm_005'],
    rsvpEventIds: ['evt_001', 'evt_003'],
  );

  static List<AppUser> allUsers = [
    currentUser,
    AppUser(
      id: 'user_002',
      name: 'Amara Diallo',
      email: 'a.diallo@alustudent.com',
      campus: 'Lagos Campus',
      program: 'Business Management',
      avatarUrl:
          'https://ui-avatars.com/api/?name=Amara+Diallo&background=4ECDC4&color=000&size=128',
      bio: 'Entrepreneur and community builder.',
      eventsCount: 12,
      communitiesCount: 3,
      connectionsCount: 54,
    ),
    AppUser(
      id: 'user_003',
      name: 'Kofi Mensah',
      email: 'k.mensah@alustudent.com',
      campus: 'Kigali Campus',
      program: 'Entrepreneurship',
      avatarUrl:
          'https://ui-avatars.com/api/?name=Kofi+Mensah&background=9B59B6&color=fff&size=128',
      bio: 'Building the next generation of African startups.',
      eventsCount: 8,
      communitiesCount: 4,
      connectionsCount: 120,
    ),
    AppUser(
      id: 'user_004',
      name: 'Fatima Al-Hassan',
      email: 'f.alhassan@alustudent.com',
      campus: 'Mauritius Campus',
      program: 'Global Challenges',
      avatarUrl:
          'https://ui-avatars.com/api/?name=Fatima+Hassan&background=E74C3C&color=fff&size=128',
      bio: 'Working on climate solutions for Africa.',
      eventsCount: 15,
      communitiesCount: 6,
      connectionsCount: 93,
    ),
  ];

  static List<Event> events = [
    Event(
      id: 'evt_001',
      title: 'ALU Hackathon 2026',
      description:
          'A 48-hour challenge designed to push the boundaries of innovation at ALU. All students are invited to form teams and build technological solutions that address pressing challenges facing Africa today. Prizes worth \$5,000 await the top teams.',
      type: EventType.hackathon,
      dateTime: DateTime(2026, 10, 15, 9, 0),
      location: 'Innovation Lab',
      campus: 'Mauritius Campus',
      organizerName: 'Tech & Innovation Hub',
      organizerId: 'user_003',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=Tech+Hub&background=4ECDC4&color=000&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&auto=format',
      tags: ['Hackathon', 'Tech', 'Innovation'],
      goingCount: 98,
      interestedCount: 43,
      isFeatured: true,
      createdAt: DateTime(2026, 6, 1),
      rsvpStatus: RsvpStatus.going,
    ),
    Event(
      id: 'evt_002',
      title: 'ALU Entrepreneurship Pitch Night',
      description:
          'Showcase your startup idea to a panel of investors, mentors, and fellow students. Get feedback, win funding, and connect with the ALU entrepreneurial ecosystem. Open to all students with a viable business concept.',
      type: EventType.event,
      dateTime: DateTime(2026, 6, 28, 18, 0),
      location: 'Kigali Campus Auditorium',
      campus: 'Kigali Campus',
      organizerName: 'Entrepreneurship Club',
      organizerId: 'user_002',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=Entrep+Club&background=F5A623&color=000&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800&auto=format',
      tags: ['Entrepreneurship', 'Startup', 'Pitch'],
      goingCount: 67,
      interestedCount: 29,
      isFeatured: true,
      createdAt: DateTime(2026, 6, 5),
    ),
    Event(
      id: 'evt_003',
      title: 'AI for Social Impact Workshop',
      description:
          'Learn how AI tools can be used to drive development in Africa. Hands-on sessions and group projects. Participants will build mini ML models to address local challenges in healthcare, agriculture, and education.',
      type: EventType.workshop,
      dateTime: DateTime(2026, 6, 5, 10, 0),
      location: 'Innovation Lab',
      campus: 'Mauritius Campus',
      organizerName: 'Software Engineering Guild',
      organizerId: 'user_001',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=SE+Guild&background=4CAF50&color=fff&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=800&auto=format',
      tags: ['Workshop', 'Tech', 'AI', 'Social Impact'],
      goingCount: 45,
      interestedCount: 19,
      isFeatured: false,
      createdAt: DateTime(2026, 5, 28),
      rsvpStatus: RsvpStatus.interested,
    ),
    Event(
      id: 'evt_004',
      title: 'Sustainable Solutions Challenge',
      description:
          'Compete in ALU\'s sustainability challenge. Design innovative solutions to pressing environmental issues across Africa. Cross-disciplinary teams encouraged. Top 3 solutions receive implementation grants.',
      type: EventType.hackathon,
      dateTime: DateTime(2026, 7, 10, 8, 0),
      location: 'ALU Main Campus',
      campus: 'Kigali Campus',
      organizerName: 'Global Challenges Team',
      organizerId: 'user_004',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=GC+Team&background=4CAF50&color=fff&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=800&auto=format',
      tags: ['Sustainability', 'Environment', 'Innovation'],
      goingCount: 34,
      interestedCount: 52,
      isFeatured: false,
      createdAt: DateTime(2026, 6, 3),
    ),
    Event(
      id: 'evt_005',
      title: 'Campus Ambassador Program',
      description:
          'Apply now to become a Campus Ambassador! Represent ALU, build leadership skills, organize events, and grow your network. This is a year-long paid leadership program open to all year 2 and 3 students.',
      type: EventType.opportunity,
      dateTime: DateTime(2026, 6, 29, 0, 0),
      location: 'Online / All Campuses',
      campus: 'All Campuses',
      organizerName: 'ALU Student Affairs',
      organizerId: 'user_002',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=Student+Affairs&background=9B59B6&color=fff&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=800&auto=format',
      tags: ['Leadership', 'Opportunity', 'Paid'],
      goingCount: 0,
      interestedCount: 78,
      isFeatured: false,
      createdAt: DateTime(2026, 6, 7),
    ),
    Event(
      id: 'evt_006',
      title: 'Build Your First MVP',
      description:
          'A beginner-friendly workshop for students who want to go from idea to working product in 3 hours. You\'ll leave with a functional prototype and pitch deck. No coding experience required.',
      type: EventType.workshop,
      dateTime: DateTime(2026, 6, 20, 14, 0),
      location: 'Design Lab, Block B',
      campus: 'Kigali Campus',
      organizerName: 'Entrepreneurship Club',
      organizerId: 'user_002',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=Entrep+Club&background=F5A623&color=000&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1553877522-43269d4ea984?w=800&auto=format',
      tags: ['Workshop', 'Startup', 'Product'],
      goingCount: 28,
      interestedCount: 15,
      isFeatured: false,
      createdAt: DateTime(2026, 6, 8),
    ),
    Event(
      id: 'evt_007',
      title: 'Women in Tech Panel',
      description:
          'Join us for an inspiring panel featuring ALU alumnae who are building careers in technology across Africa. Open discussion, Q&A, and networking opportunity.',
      type: EventType.event,
      dateTime: DateTime(2026, 6, 25, 16, 0),
      location: 'Conference Room A',
      campus: 'Lagos Campus',
      organizerName: 'Women in Leadership',
      organizerId: 'user_004',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=Women+Leadership&background=E74C3C&color=fff&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&auto=format',
      tags: ['Women', 'Tech', 'Panel', 'Networking'],
      goingCount: 56,
      interestedCount: 32,
      isFeatured: false,
      createdAt: DateTime(2026, 6, 6),
    ),
    Event(
      id: 'evt_008',
      title: 'ALU Climate Action Week',
      description:
          'A week of talks, workshops, and community projects focused on climate action and sustainable development. Every student can participate and contribute to creating climate solutions.',
      type: EventType.community,
      dateTime: DateTime(2026, 7, 1, 9, 0),
      location: 'Entire Campus',
      campus: 'All Campuses',
      organizerName: 'Global Challenges Team',
      organizerId: 'user_004',
      organizerAvatarUrl:
          'https://ui-avatars.com/api/?name=GC+Team&background=4CAF50&color=fff&size=64',
      imageUrl:
          'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=800&auto=format',
      tags: ['Climate', 'Sustainability', 'Community'],
      goingCount: 112,
      interestedCount: 67,
      isFeatured: false,
      createdAt: DateTime(2026, 6, 4),
    ),
  ];

  static List<Community> communities = [
    Community(
      id: 'comm_001',
      name: 'Software Engineering Guild',
      description:
          'Building the future of African tech. We code, collaborate, and ship products. Weekly code reviews, hackathons, and mentorship sessions.',
      category: 'Technology',
      imageUrl:
          'https://ui-avatars.com/api/?name=SE+Guild&background=4ECDC4&color=000&size=128',
      memberCount: 234,
      leaderId: 'user_001',
      leaderName: 'Jean Nishimwe',
      createdAt: DateTime(2025, 9, 1),
      isJoined: true,
    ),
    Community(
      id: 'comm_002',
      name: 'Entrepreneurship Club',
      description:
          'For founders, future founders, and startup enthusiasts. Pitch nights, investor meetups, and startup resources.',
      category: 'Business',
      imageUrl:
          'https://ui-avatars.com/api/?name=Entrep+Club&background=F5A623&color=000&size=128',
      memberCount: 187,
      leaderId: 'user_002',
      leaderName: 'Amara Diallo',
      createdAt: DateTime(2025, 9, 5),
    ),
    Community(
      id: 'comm_003',
      name: 'ALU Debate Society',
      description:
          'Sharpen your critical thinking and public speaking. Weekly debates on African governance, global affairs, and campus issues.',
      category: 'Academic',
      imageUrl:
          'https://ui-avatars.com/api/?name=Debate+Society&background=9B59B6&color=fff&size=128',
      memberCount: 95,
      leaderId: 'user_003',
      leaderName: 'Kofi Mensah',
      createdAt: DateTime(2025, 10, 1),
      isJoined: true,
    ),
    Community(
      id: 'comm_004',
      name: 'Women in Leadership',
      description:
          'Empowering women at ALU through mentorship, leadership development, and community building. All genders welcome.',
      category: 'Leadership',
      imageUrl:
          'https://ui-avatars.com/api/?name=Women+Leadership&background=E74C3C&color=fff&size=128',
      memberCount: 142,
      leaderId: 'user_004',
      leaderName: 'Fatima Al-Hassan',
      createdAt: DateTime(2025, 9, 15),
    ),
    Community(
      id: 'comm_005',
      name: 'Tech & Innovation Hub',
      description:
          'Exploring emerging technologies: AI, blockchain, IoT, and more. Host of the annual ALU Hackathon.',
      category: 'Technology',
      imageUrl:
          'https://ui-avatars.com/api/?name=Tech+Hub&background=3498DB&color=fff&size=128',
      memberCount: 312,
      leaderId: 'user_003',
      leaderName: 'Kofi Mensah',
      createdAt: DateTime(2025, 8, 20),
      isJoined: true,
    ),
    Community(
      id: 'comm_006',
      name: 'Travel Buddies',
      description:
          'Exploring Africa together. Group trips, travel tips, and adventure planning for ALU students.',
      category: 'Lifestyle',
      imageUrl:
          'https://ui-avatars.com/api/?name=Travel+Buddies&background=27AE60&color=fff&size=128',
      memberCount: 78,
      leaderId: 'user_002',
      leaderName: 'Amara Diallo',
      createdAt: DateTime(2025, 11, 1),
    ),
    Community(
      id: 'comm_007',
      name: 'Campus Leaders',
      description:
          'Official network of campus leaders, club presidents, and student representatives across all ALU campuses.',
      category: 'Leadership',
      imageUrl:
          'https://ui-avatars.com/api/?name=Campus+Leaders&background=F39C12&color=fff&size=128',
      memberCount: 56,
      leaderId: 'user_004',
      leaderName: 'Fatima Al-Hassan',
      createdAt: DateTime(2025, 9, 1),
    ),
    Community(
      id: 'comm_008',
      name: 'ALU Debate Society',
      description:
          'Ekimanuka ubuhanzi. Arts, culture, and creative expression at ALU. Open mics, exhibitions, and performances.',
      category: 'Arts & Culture',
      imageUrl:
          'https://ui-avatars.com/api/?name=ALU+Arts&background=8E44AD&color=fff&size=128',
      memberCount: 63,
      leaderId: 'user_002',
      leaderName: 'Amara Diallo',
      createdAt: DateTime(2025, 10, 15),
    ),
  ];

  static List<ChatRoom> chatRooms = [
    ChatRoom(
      id: 'chat_001',
      name: 'AI Workshop Group',
      communityId: 'comm_001',
      imageUrl:
          'https://ui-avatars.com/api/?name=AI+Workshop&background=4ECDC4&color=000&size=64',
      participantIds: ['user_001', 'user_002', 'user_003', 'user_004'],
      isGroup: true,
      onlineCount: 12,
      messages: [
        ChatMessage(
          id: 'msg_001',
          senderId: 'user_002',
          senderName: 'Amara',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Amara+Diallo&background=4ECDC4&color=000&size=40',
          text:
              'Hey team! Don\'t forget our session tomorrow at 10am. See you there! 🚀',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isMe: false,
        ),
        ChatMessage(
          id: 'msg_002',
          senderId: 'user_001',
          senderName: 'Jean',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Jean+Nishimwe&background=F5A623&color=000&size=40',
          text: 'Can\'t wait! I\'ve been preparing my laptop 💻',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          isMe: true,
        ),
        ChatMessage(
          id: 'msg_003',
          senderId: 'user_003',
          senderName: 'Kofi',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Kofi+Mensah&background=9B59B6&color=fff&size=40',
          text: 'Same here! What should we bring?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          isMe: false,
        ),
        ChatMessage(
          id: 'msg_004',
          senderId: 'user_002',
          senderName: 'Amara',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Amara+Diallo&background=4ECDC4&color=000&size=40',
          text: 'Just your laptop and enthusiasm! Materials will be provided.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          isMe: false,
        ),
      ],
    ),
    ChatRoom(
      id: 'chat_002',
      name: 'Entrepreneurship Club',
      communityId: 'comm_002',
      imageUrl:
          'https://ui-avatars.com/api/?name=Entrep+Club&background=F5A623&color=000&size=64',
      participantIds: ['user_001', 'user_002', 'user_004'],
      isGroup: true,
      onlineCount: 8,
      messages: [
        ChatMessage(
          id: 'msg_005',
          senderId: 'user_002',
          senderName: 'Amara',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Amara+Diallo&background=4ECDC4&color=000&size=40',
          text: 'Pitch night slots are filling up fast! Sign up ASAP.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isMe: false,
        ),
        ChatMessage(
          id: 'msg_006',
          senderId: 'user_001',
          senderName: 'Jean',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Jean+Nishimwe&background=F5A623&color=000&size=40',
          text: 'Just registered! Super excited for this.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          isMe: true,
        ),
      ],
    ),
    ChatRoom(
      id: 'chat_003',
      name: 'Campus Leaders',
      communityId: 'comm_007',
      imageUrl:
          'https://ui-avatars.com/api/?name=Campus+Leaders&background=F39C12&color=fff&size=64',
      participantIds: ['user_001', 'user_003', 'user_004'],
      isGroup: true,
      onlineCount: 5,
      messages: [
        ChatMessage(
          id: 'msg_007',
          senderId: 'user_004',
          senderName: 'Fatima',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Fatima+Hassan&background=E74C3C&color=fff&size=40',
          text: 'Monthly check-in this Friday at 4pm. Please confirm attendance.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isMe: false,
        ),
      ],
    ),
    ChatRoom(
      id: 'chat_004',
      name: 'Travel Buddies',
      communityId: 'comm_006',
      imageUrl:
          'https://ui-avatars.com/api/?name=Travel+Buddies&background=27AE60&color=fff&size=64',
      participantIds: ['user_001', 'user_002'],
      isGroup: true,
      onlineCount: 3,
      messages: [
        ChatMessage(
          id: 'msg_008',
          senderId: 'user_002',
          senderName: 'Amara',
          senderAvatarUrl:
              'https://ui-avatars.com/api/?name=Amara+Diallo&background=4ECDC4&color=000&size=40',
          text: 'Anyone interested in Zanzibar trip in August? 🌴',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          isMe: false,
        ),
      ],
    ),
  ];
}
