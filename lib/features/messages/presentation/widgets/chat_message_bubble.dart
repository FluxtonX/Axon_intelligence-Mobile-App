import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.time,
    this.isMe = false,
  });

  final String message;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
            ),
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: isMe ? Colors.white : const Color(0xFF111827),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 8,
              right: isMe ? 8 : 0,
            ),
            child: Text(
              time,
              style: AppTypography.caption.copyWith(color: const Color(0xFF9CA3AF)),
            ),
          ),
        ],
      ),
    );
  }
}
