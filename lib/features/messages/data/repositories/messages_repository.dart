import '../../../../core/network/api_client.dart';

class MessagesRepository {
  final ApiClient _apiClient;

  MessagesRepository(this._apiClient);

  /// Global current user ID in client mode
  static const String currentUserId = 'client_user_me';

  // Persistent in-memory message store keyed by chat ID
  final Map<String, List<Map<String, dynamic>>> _inMemoryMessages = {
    'alex_morgan': [
      {
        'id': 'msg_2',
        'senderId': currentUserId,
        'content': 'Awesome! Let me know if you need any extra details about the brief.',
        'createdAt': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
        'isRead': true,
      },
      {
        'id': 'msg_1',
        'senderId': 'alex_morgan',
        'content': 'Hi there! I reviewed your project requirements and I am excited to collaborate.',
        'createdAt': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        'isRead': true,
      },
    ],
    'elena_rostova': [
      {
        'id': 'msg_3',
        'senderId': 'elena_rostova',
        'content': 'Hi! The UI/UX prototypes for your app are ready for review.',
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'isRead': false,
      },
    ],
  };

  // Mock User Metadata Map for dynamic threads
  final Map<String, Map<String, dynamic>> _userProfiles = {
    'alex_morgan': {
      'id': 'alex_morgan',
      'email': 'alex@example.com',
      'profile': {
        'firstName': 'Alex',
        'lastName': 'Morgan',
        'avatarUrl': 'https://i.pravatar.cc/150?img=5',
        'title': 'Senior Flutter Architect',
      }
    },
    'elena_rostova': {
      'id': 'elena_rostova',
      'email': 'elena@example.com',
      'profile': {
        'firstName': 'Elena',
        'lastName': 'Rostova',
        'avatarUrl': 'https://i.pravatar.cc/150?img=9',
        'title': 'UI/UX Designer',
      }
    },
  };

  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _apiClient.dio.get('/messages');
      return response.data;
    } catch (e) {
      // Build dynamic Fiverr-style conversation list from active memory store
      final List<dynamic> conversations = [];

      _inMemoryMessages.forEach((chatId, messages) {
        if (messages.isNotEmpty) {
          final lastMsg = messages.first;
          final isSentByMe = lastMsg['senderId'] == currentUserId;
          final userMeta = _userProfiles[chatId] ?? {
            'id': chatId,
            'email': '$chatId@example.com',
            'profile': {
              'firstName': chatId.split('_').first.toUpperCase(),
              'lastName': chatId.contains('_') ? chatId.split('_').last.toUpperCase() : '',
              'avatarUrl': 'https://i.pravatar.cc/150?img=12',
              'title': 'Freelance Expert',
            }
          };

          // Count unread incoming messages
          final unreadCount = messages.where((m) => m['senderId'] != currentUserId && (m['isRead'] == false)).length;

          conversations.add({
            'id': chatId,
            'unreadCount': unreadCount,
            'user': userMeta,
            'lastMessage': {
              'content': isSentByMe ? 'You: ${lastMsg['content']}' : lastMsg['content'],
              'createdAt': lastMsg['createdAt'],
            }
          });
        }
      });

      return conversations;
    }
  }

  Future<Map<String, dynamic>> getConversation(String otherUserId, {int page = 1}) async {
    // Mark all incoming messages in this thread as READ (Fiverr auto-read feature)
    if (_inMemoryMessages.containsKey(otherUserId)) {
      for (var msg in _inMemoryMessages[otherUserId]!) {
        if (msg['senderId'] != currentUserId) {
          msg['isRead'] = true;
        }
      }
    } else {
      // Initialize fresh thread with opponent greeting
      _inMemoryMessages[otherUserId] = [
        {
          'id': 'msg_init_${DateTime.now().millisecondsSinceEpoch}',
          'senderId': otherUserId,
          'content': 'Hi! Thank you for reaching out. How can I help you with your project?',
          'createdAt': DateTime.now().toIso8601String(),
          'isRead': true,
        }
      ];
    }

    try {
      final response = await _apiClient.dio.get(
        '/messages/conversation/$otherUserId',
        queryParameters: {'page': page},
      );
      return response.data;
    } catch (e) {
      return {
        'messages': List<Map<String, dynamic>>.from(_inMemoryMessages[otherUserId] ?? []),
      };
    }
  }

  Future<void> sendMessage(String receiverId, String content, {String senderRole = 'client'}) async {
    final senderId = senderRole == 'freelancer' ? 'freelancer_me' : 'client_user_me';
    
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': senderId,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
      'isRead': true,
    };

    if (_inMemoryMessages.containsKey(receiverId)) {
      _inMemoryMessages[receiverId]!.insert(0, newMessage);
    } else {
      _inMemoryMessages[receiverId] = [newMessage];
    }

    try {
      await _apiClient.dio.post(
        '/messages',
        data: {'receiverId': receiverId, 'content': content},
      );
    } catch (e) {
      // Mock sent response retained in memory
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _apiClient.dio.patch('/messages/$messageId/read');
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }
}
