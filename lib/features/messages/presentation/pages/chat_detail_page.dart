import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/milestone_action_card.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.name,
  });

  final String chatId;
  final String name;

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
            CircleAvatar(
              radius: 16,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=5'), // Mock avatar based on name usually
              backgroundColor: const Color(0xFFF3F4F6),
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              reverse: true, // typical for chat
              children: [
                const ChatMessageBubble(
                  message: 'I have uploaded the final Figma files for the onboarding flow.',
                  time: '10:42 AM',
                  isMe: false,
                ),
                const MilestoneActionCard(
                  title: 'UI Design - Onboarding Flow Delivery',
                  amount: 450.00,
                  status: 'Awaiting your approval',
                  isActionable: true,
                ),
                const ChatMessageBubble(
                  message: 'Sounds great. I will review them and release the milestone shortly.',
                  time: 'Yesterday 4:15 PM',
                  isMe: true,
                ),
                const ChatMessageBubble(
                  message: 'Hi! Just letting you know I have completed the first draft of the designs.',
                  time: 'Yesterday 3:30 PM',
                  isMe: false,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      'Yesterday',
                      style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const MilestoneActionCard(
                  title: 'Project Kickoff - Contract Signed',
                  amount: 0.00,
                  status: 'Active Contract',
                  isActionable: false,
                ),
              ].reversed.toList(),
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
                  onTap: () {},
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
