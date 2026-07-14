import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = unreadCount > 0;

    return InkWell(
      onTap: () => context.push('/chat/$id', extra: name),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with Online Status
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: const Color(0xFFF3F4F6),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Name and Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.headingSmall.copyWith(
                      color: const Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: AppTypography.bodyMedium.copyWith(
                      color: hasUnread ? const Color(0xFF111827) : const Color(0xFF6B7280),
                      fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Time and Unread Count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: AppTypography.caption.copyWith(
                    color: hasUnread ? AppColors.primary : const Color(0xFF9CA3AF),
                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20), // Placeholder to maintain alignment
              ],
            ),
          ],
        ),
      ),
    );
  }
}
