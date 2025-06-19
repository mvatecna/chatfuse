import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onNewChat;
  final String searchQuery;

  const EmptyStateWidget({
    super.key,
    required this.onNewChat,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration Container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: isSearching ? 'search_off' : 'chat_bubble_outline',
                color: theme.colorScheme.primary,
                size: 60,
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              isSearching ? 'No Results Found' : 'Welcome to ChatFuse',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              isSearching
                  ? 'Try adjusting your search terms or filters to find what you\'re looking for.'
                  : 'Start your first conversation with AI assistants from multiple providers. Choose your preferred model and begin chatting.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Button
            if (!isSearching) ...[
              ElevatedButton.icon(
                onPressed: onNewChat,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: theme.elevatedButtonTheme.style?.foregroundColor
                          ?.resolve({}) ??
                      Colors.white,
                  size: 20,
                ),
                label: Text('Start Your First Chat'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Feature Highlights
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      context,
                      icon: 'security',
                      title: 'Your API Keys',
                      description: 'Secure local storage for your API keys',
                    ),
                    Divider(height: 3.h),
                    _buildFeatureItem(
                      context,
                      icon: 'swap_horiz',
                      title: 'Multiple Providers',
                      description: 'OpenAI, Anthropic, Mistral, Cohere & more',
                    ),
                    Divider(height: 3.h),
                    _buildFeatureItem(
                      context,
                      icon: 'offline_bolt',
                      title: 'Offline History',
                      description: 'Access your conversations anytime',
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Search suggestions for empty results
              OutlinedButton.icon(
                onPressed: () {
                  // Clear search and show all chats
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                label: Text('Clear Search'),
                style: OutlinedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
