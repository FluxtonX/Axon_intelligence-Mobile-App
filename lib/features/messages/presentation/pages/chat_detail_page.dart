import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/milestone_action_card.dart';
import '../blocs/chat_detail_bloc.dart';
import '../blocs/chat_detail_event.dart';
import '../blocs/chat_detail_state.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.name,
    this.avatarUrl = 'https://i.pravatar.cc/150?img=5',
  });

  final String chatId;
  final String name;
  final String avatarUrl;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'avatar_${widget.chatId}',
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.avatarUrl),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: AppTypography.headingSmall.copyWith(fontSize: 16, color: AppColors.textDark),
                  ),
                  Text(
                    'Online • local time 2:15 PM',
                    style: AppTypography.caption.copyWith(color: const Color(0xFF10B981)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Chat history
          Expanded(
            child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
              builder: (context, state) {
                if (state.status == ChatDetailStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state.status == ChatDetailStatus.failure) {
                  return Center(child: Text('Failed to load messages: ${state.errorMessage}'));
                }
                
                if (state.messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }
                
                final userId = context.read<UserModeCubit>().state == UserMode.client 
                  ? 'client_id_placeholder' // We'd ideally have actual user ID in a real app, assuming simple check for now
                  : 'freelancer_id_placeholder'; 
                  
                // Note: To properly know `isMe`, we need the current user's ID. 
                // As a simplification without auth state context here, we check `senderId` against `otherUserId`.
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  reverse: true,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    final isMe = msg['senderId'] != widget.chatId;
                    
                    // Simple formatting for time
                    final date = DateTime.parse(msg['createdAt']);
                    final timeString = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
                    
                    return ChatMessageBubble(
                      message: msg['content'],
                      time: timeString,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom > 0 
                  ? MediaQuery.of(context).padding.bottom + 8 
                  : 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_rounded, color: Color(0xFF9CA3AF), size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _textController,
                      style: AppTypography.bodyMedium,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (_textController.text.trim().isNotEmpty) {
                      context.read<ChatDetailBloc>().add(
                        SendMessage(
                          otherUserId: widget.chatId,
                          content: _textController.text,
                        ),
                      );
                      _textController.clear();
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
