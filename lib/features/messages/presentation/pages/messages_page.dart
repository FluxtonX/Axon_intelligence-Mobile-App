import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/animations/fade_in_slide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/conversation_tile.dart';
import '../blocs/conversations_bloc.dart';
import '../blocs/conversations_state.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Messages',
            style: AppTypography.headingMedium.copyWith(color: AppColors.textDark),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textDark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          if (state.status == ConversationsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ConversationsStatus.failure) {
            return Center(child: Text('Failed to load conversations: ${state.errorMessage}'));
          }

          if (state.conversations.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }

          final unread = state.conversations.where((c) => (c['unreadCount'] as int) > 0).toList();
          final read = state.conversations.where((c) => (c['unreadCount'] as int) == 0).toList();

          return ListView(
            children: [
              if (unread.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    'Unread',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ...unread.asMap().entries.map((entry) {
                  final index = entry.key;
                  final chat = entry.value;
                  final user = chat['user'];
                  final lastMessage = chat['lastMessage']['content'];
                  return FadeInSlide(
                    delay: Duration(milliseconds: index * 100),
                    child: ConversationTile(
                      id: user['id'], // use user id as chat id to easily route
                      name: user['profile'] != null 
                        ? '${user['profile']['firstName']} ${user['profile']['lastName'] ?? ''}'.trim()
                        : 'Unknown User',
                      lastMessage: lastMessage,
                      time: '', // Format properly if needed
                      avatarUrl: user['profile']?['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=${user['id']}',
                      unreadCount: chat['unreadCount'],
                      isOnline: true, // Mock online
                    ),
                  );
                }),
              ],
              if (read.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    'All Messages',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ...read.asMap().entries.map((entry) {
                  final index = entry.key;
                  final chat = entry.value;
                  final user = chat['user'];
                  final lastMessage = chat['lastMessage']['content'];
                  return FadeInSlide(
                    delay: Duration(milliseconds: 200 + (index * 100)),
                    child: ConversationTile(
                      id: user['id'],
                      name: user['profile'] != null 
                        ? '${user['profile']['firstName']} ${user['profile']['lastName'] ?? ''}'.trim()
                        : 'Unknown User',
                      lastMessage: lastMessage,
                      time: '',
                      avatarUrl: user['profile']?['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=${user['id']}',
                      unreadCount: 0,
                      isOnline: false,
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }
}
