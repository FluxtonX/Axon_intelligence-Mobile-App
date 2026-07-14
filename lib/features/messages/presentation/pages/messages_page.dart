import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/conversation_tile.dart';

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
      body: ListView(
        children: const [
          Padding(
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
          ConversationTile(
            id: 'chat_1',
            name: 'Sophia Chen',
            lastMessage: 'I have uploaded the final Figma files for the onboarding flow.',
            time: '10:42 AM',
            avatarUrl: 'https://i.pravatar.cc/150?img=5',
            unreadCount: 2,
            isOnline: true,
          ),
          ConversationTile(
            id: 'chat_2',
            name: 'Marcus Williams',
            lastMessage: 'Could you review the milestone I just submitted?',
            time: '9:15 AM',
            avatarUrl: 'https://i.pravatar.cc/150?img=11',
            unreadCount: 1,
            isOnline: false,
          ),
          Padding(
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
          ConversationTile(
            id: 'chat_3',
            name: 'Yuki Tanaka',
            lastMessage: 'Thanks! I will get started on the 3D assets tomorrow.',
            time: 'Yesterday',
            avatarUrl: 'https://i.pravatar.cc/150?img=12',
            isOnline: true,
          ),
          ConversationTile(
            id: 'chat_4',
            name: 'TechNova Agency',
            lastMessage: 'The contract has been approved. Funds are in escrow.',
            time: 'Monday',
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
            isOnline: false,
          ),
          ConversationTile(
            id: 'chat_5',
            name: 'Emma Watson',
            lastMessage: 'Are you available for a quick sync later today?',
            time: 'Jul 10',
            avatarUrl: 'https://i.pravatar.cc/150?img=9',
            isOnline: false,
          ),
        ],
      ),
    );
  }
}
