import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onSwipeUp;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    this.onSwipeUp,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message["isUser"] as bool;
    final content = message["content"] as String;
    final timestamp = message["timestamp"] as DateTime;

    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy < -5 && onSwipeUp != null) {
          onSwipeUp!();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(right: 2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: CustomIconWidget(
                  iconName: 'smart_toy',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 16,
                ),
              ),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 75.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isUser ? 4.w : 1.w),
                    topRight: Radius.circular(isUser ? 1.w : 4.w),
                    bottomLeft: Radius.circular(4.w),
                    bottomRight: Radius.circular(4.w),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser && message["provider"] != null) ...[
                      Row(
                        children: [
                          Text(
                            message["provider"] as String,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 1,
                            height: 3.w,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            message["model"] as String,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                    ],
                    _buildMessageContent(context, content, isUser),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(timestamp),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: isUser
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                            .withValues(alpha: 0.7)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                        ),
                        if (message["tokenCount"] != null) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'token',
                            color: isUser
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withValues(alpha: 0.7)
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${message["tokenCount"]}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: isUser
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withValues(alpha: 0.7)
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.only(left: 2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(
      BuildContext context, String content, bool isUser) {
    // Simple markdown-like rendering for bold text
    final parts = content.split('**');
    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // Regular text
        spans.add(TextSpan(
          text: parts[i],
          style: AppTheme.getChatTextStyle(
            isLight: Theme.of(context).brightness == Brightness.light,
            isUser: isUser,
          ),
        ));
      } else {
        // Bold text
        spans.add(TextSpan(
          text: parts[i],
          style: AppTheme.getChatTextStyle(
            isLight: Theme.of(context).brightness == Brightness.light,
            isUser: isUser,
          ).copyWith(fontWeight: FontWeight.w600),
        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
