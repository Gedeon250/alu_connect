class ChatRoom {
  final String id;
  final String name;
  final String? communityId;
  final String imageUrl;
  final List<String> participantIds;
  final List<ChatMessage> messages;
  final bool isGroup;
  final int onlineCount;

  ChatRoom({
    required this.id,
    required this.name,
    this.communityId,
    required this.imageUrl,
    required this.participantIds,
    required this.messages,
    required this.isGroup,
    this.onlineCount = 0,
  });

  ChatMessage? get lastMessage =>
      messages.isEmpty ? null : messages.last;
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? fileUrl;
  final String? fileName;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.fileUrl,
    this.fileName,
  });
}
