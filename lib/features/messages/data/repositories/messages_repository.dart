import '../../../../core/network/api_client.dart';
import '../../../../core/network/socket_client.dart';
import '../../../../core/storage/secure_storage.dart';
import 'dart:async';
import 'dart:convert';

class MessagesRepository {
  final ApiClient _apiClient;
  final SocketClient _socketClient;
  final SecureStorage _storage;
  
  final _messageStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get incomingMessages => _messageStreamController.stream;

  MessagesRepository(this._apiClient, this._socketClient, this._storage);

  /// Decodes JWT to get the user ID
  String? _getUserIdFromToken() {
    final token = _storage.getToken();
    if (token == null) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final data = json.decode(payload);
      return data['sub']; // userId
    } catch (e) {
      return null;
    }
  }

  void initializeSocket() {
    final userId = _getUserIdFromToken();
    if (userId != null) {
      _socketClient.connect(userId);
      
      // Listen for real-time messages from the backend
      _socketClient.on('messageToUser-$userId', (data) {
        if (data != null) {
          final message = Map<String, dynamic>.from(data);
          
          // Add to in-memory store for immediate display
          final senderId = message['senderId'];
          if (_inMemoryMessages.containsKey(senderId)) {
            _inMemoryMessages[senderId]!.insert(0, message);
          } else {
            _inMemoryMessages[senderId] = [message];
          }

          // Broadcast to the UI Blocs
          _messageStreamController.add(message);
        }
      });
    }
  }

  void dispose() {
    _messageStreamController.close();
  }

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
      print('GET CONVERSATIONS SUCCESS: ${response.data}');
      return response.data;
    } catch (e) {
      print('ERROR GETTING CONVERSATIONS FROM BACKEND: $e');
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
              'firstName': 'Unknown',
              'lastName': 'User',
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
      print('MESSAGE SENT TO BACKEND SUCCESSFULLY');
    } catch (e) {
      print('ERROR SENDING MESSAGE TO BACKEND: $e');
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
