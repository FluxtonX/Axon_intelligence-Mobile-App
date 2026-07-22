import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/chat_message_bubble.dart';
import '../blocs/chat_detail_bloc.dart';
import '../blocs/chat_detail_event.dart';
import '../blocs/chat_detail_state.dart';
import '../blocs/conversations_bloc.dart';
import '../blocs/conversations_event.dart';
import '../../data/repositories/messages_repository.dart';
import '../../../../core/blocs/user_mode_cubit.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
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
          onPressed: () {
            context.read<ConversationsBloc>().add(const FetchConversations());
            context.pop();
          },
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
          if (context.watch<UserModeCubit>().state == UserMode.client)
            TextButton.icon(
              onPressed: () {
                context.pushNamed(
                  'directHire',
                  extra: {
                    'freelancerId': widget.chatId,
                    'freelancerName': widget.name,
                  },
                );
              },
              icon: const Icon(Icons.add_box_rounded, color: AppColors.primary, size: 20),
              label: Text(
                'Create Offer',
                style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
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

                final userMode = context.watch<UserModeCubit>().state;
                final mySenderId = userMode == UserMode.freelancer ? 'freelancer_me' : 'client_user_me';
                
                // Get the real backend UUID if logged in
                final profileState = context.read<ProfileCubit>().state;
                final String? realCurrentUserId = profileState is ProfileLoaded ? profileState.user.id.toLowerCase() : null;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  reverse: true,
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    final senderId = msg['senderId']?.toString().toLowerCase() ?? msg['sender_id']?.toString().toLowerCase() ?? '';
                    final chatId = widget.chatId.toLowerCase();
                    
                    // Bulletproof Identity Rule:
                    // 1. If senderId matches real backend logged-in user ID
                    // 2. Or matches mock active mode ID ('freelancer_me' / 'client_user_me')
                    // 3. Or it's NOT the opponent's ID and we don't have a real UserID clash.
                    bool isMe = false;
                    
                    if (realCurrentUserId != null && senderId == realCurrentUserId) {
                       isMe = true;
                    } else if (senderId == mySenderId || senderId == 'me' || senderId == 'client') {
                       isMe = true;
                    } else if (senderId.isNotEmpty && senderId != chatId) {
                       isMe = true;
                    }

                    // Special Edge Case: If the user is chatting with THEMSELVES (realCurrentUserId == chatId),
                    // the API will return identical senderIds. In this case, we have to fallback to the optimistic
                    // local sender string if available, otherwise it's impossible to tell, so default to right-aligned for all.
                    if (realCurrentUserId != null && realCurrentUserId == chatId) {
                        isMe = true; 
                    }
                    
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
          // Clean Modern Floating Input Bar
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom > 0 
                  ? MediaQuery.of(context).padding.bottom + 6 
                  : 12,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFF3F4F6), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Plus Attachment Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Color(0xFF4B5563),
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                
                // Rounded Text Input Field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: AppColors.primary,
                        scaffoldBackgroundColor: Colors.transparent,
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: AppColors.primary,
                          selectionColor: AppColors.primary.withValues(alpha: 0.25),
                          selectionHandleColor: AppColors.primary,
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: AppColors.primary,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          if (_textController.text.trim().isNotEmpty) {
                            final mode = context.read<UserModeCubit>().state;
                            final role = mode == UserMode.freelancer ? 'freelancer' : 'client';
                            context.read<ChatDetailBloc>().add(
                              SendMessage(
                                otherUserId: widget.chatId,
                                content: _textController.text,
                                senderRole: role,
                              ),
                            );
                            _textController.clear();
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          fillColor: Colors.transparent,
                          filled: false,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 11),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Floating Send Action Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      if (_textController.text.trim().isNotEmpty) {
                        final mode = context.read<UserModeCubit>().state;
                        final role = mode == UserMode.freelancer ? 'freelancer' : 'client';
                        context.read<ChatDetailBloc>().add(
                          SendMessage(
                            otherUserId: widget.chatId,
                            content: _textController.text,
                            senderRole: role,
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
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
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
