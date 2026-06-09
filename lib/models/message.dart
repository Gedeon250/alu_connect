// Chat conversation preview (shown in the Chats list screen)
class ChatPreview {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int    unreadCount;
  final String avatarEmoji;

  const ChatPreview({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatarEmoji,
  });
}

// Individual chat message (shown inside a chat room)
class ChatMessage {
  final String  id;
  final String  senderName;
  final String  content;
  final String  timestamp;
  final bool    isMe;
  final bool    hasAttachment;
  final String  attachmentName;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.hasAttachment  = false,
    this.attachmentName = '',
  });
}
