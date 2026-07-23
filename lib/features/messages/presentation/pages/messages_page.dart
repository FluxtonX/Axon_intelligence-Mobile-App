import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/animations/fade_in_slide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/data/auth_repository.dart';
import '../widgets/conversation_tile.dart';
import '../blocs/conversations_bloc.dart';
import '../blocs/conversations_event.dart';
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
      body: Builder(
        builder: (context) {
          final authRepo = RepositoryProvider.of<AuthRepository>(context);
          if (!authRepo.isLoggedIn()) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_bubble_outline_rounded, size: 64, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your Messages',
                      style: AppTypography.headingMedium.copyWith(color: AppColors.textDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to chat with freelancers and clients, discuss projects, and negotiate terms.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => context.go('/auth'),
                      child: const Text('Sign In / Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          }

          return BlocBuilder<ConversationsBloc, ConversationsState>(
            builder: (context, state) {
              if (state.status == ConversationsStatus.initial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ConversationsBloc>().add(const FetchConversations());
            });
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ConversationsStatus.loading && state.conversations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = state.conversations;
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Color(0xFF9CA3AF)),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: AppTypography.headingSmall.copyWith(color: AppColors.textDark),
                  ),
                ],
              ),
            );
          }

          final unread = conversations.where((c) => (c['unreadCount'] as int? ?? 0) > 0).toList();
          final read = conversations.where((c) => (c['unreadCount'] as int? ?? 0) == 0).toList();

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
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
                ...unread.map((chat) {
                  final user = chat['user'];
                  final lastMessage = chat['lastMessage']['content'];
                  return ConversationTile(
                    id: user['id'],
                    name: user['profile'] != null 
                      ? '${user['profile']['firstName']} ${user['profile']['lastName'] ?? ''}'.trim()
                      : 'Unknown User',
                    lastMessage: lastMessage,
                    time: '15m ago',
                    avatarUrl: user['profile']?['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=${user['id']}',
                    unreadCount: chat['unreadCount'],
                    isOnline: true,
                  );
                }),
              ],
              if (read.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                ...read.map((chat) {
                  final user = chat['user'];
                  final lastMessage = chat['lastMessage']['content'];
                  return ConversationTile(
                    id: user['id'],
                    name: user['profile'] != null 
                      ? '${user['profile']['firstName']} ${user['profile']['lastName'] ?? ''}'.trim()
                      : 'Unknown User',
                    lastMessage: lastMessage,
                    time: '3h ago',
                    avatarUrl: user['profile']?['avatarUrl'] ?? 'https://i.pravatar.cc/150?u=${user['id']}',
                    unreadCount: 0,
                    isOnline: false,
                  );
                }),
              ],
            ],
          );
        },
      );
        },
      ),
    );
  }
}
