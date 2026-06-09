import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../data/mock_data.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatRoom> _chatRooms = List.from(MockData.chatRooms);

  List<ChatRoom> get chatRooms => _chatRooms;

  // Get a chat room by id
  ChatRoom? getChatRoom(String id) {
    for (ChatRoom room in _chatRooms) {
      if (room.id == id) {
        return room;
      }
    }
    return null;
  }

  // Send a message in a chat room
  void sendMessage(String chatRoomId, String text) {
    for (int i = 0; i < _chatRooms.length; i++) {
      if (_chatRooms[i].id == chatRoomId) {
        // Create the message using current time as id
        ChatMessage message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: MockData.currentUser.id,
          senderName: MockData.currentUser.name,
          senderAvatarUrl: MockData.currentUser.avatarUrl,
          text: text,
          timestamp: DateTime.now(),
          isMe: true,
        );

        _chatRooms[i].messages.add(message);
        notifyListeners();

        // Simulate a reply after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          _sendAutoReply(chatRoomId);
        });

        break;
      }
    }
  }

  void _sendAutoReply(String chatRoomId) {
    List<String> replies = [
      'That sounds great!',
      'Thanks for sharing!',
      'I will be there!',
      'Can you send more details?',
      'Count me in!',
      'Looking forward to it!',
      'Awesome, see you soon!',
    ];

    for (int i = 0; i < _chatRooms.length; i++) {
      if (_chatRooms[i].id == chatRoomId) {
        // Pick a random reply and sender
        int replyIndex = DateTime.now().millisecond % replies.length;
        int userIndex = (DateTime.now().millisecond % 3) + 1;
        AppUser sender = MockData.allUsers[userIndex];

        ChatMessage reply = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: sender.id,
          senderName: sender.name.split(' ').first,
          senderAvatarUrl: sender.avatarUrl,
          text: replies[replyIndex],
          timestamp: DateTime.now(),
          isMe: false,
        );

        _chatRooms[i].messages.add(reply);
        notifyListeners();
        break;
      }
    }
  }
}
