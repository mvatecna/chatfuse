import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ValidationStatusWidget extends StatelessWidget {
  final String status; // empty, invalid, valid
  final bool isValidating;
  final Map<String, dynamic> provider;
  final String apiKey;

  const ValidationStatusWidget({
    super.key,
    required this.status,
    required this.isValidating,
    required this.provider,
    required this.apiKey,
  });

  @override
  Widget build(BuildContext context) {
    if (isValidating) {
      return _buildValidatingState(context);
    }

    switch (status) {
      case 'empty':
        return _buildEmptyState(context);
      case 'invalid':
        return _buildInvalidState(context);
      case 'valid':
        return _buildValidState(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildValidatingState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Validating API key format...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .onSurfaceVariant
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'help_outline',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Need an API key?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              // Open help URL
            },
            child: Text(
              'Get your ${provider['name']} API key from their developer console',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryLight,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.errorColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.errorColor,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Invalid API key format. Expected format: ${provider['keyFormat']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidState(BuildContext context) {
    final maskedKey = _maskApiKey(apiKey);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle_outline',
                color: AppTheme.successColor,
                size: 16,
              ),
              SizedBox(width: 3.w),
              Text(
                'Valid API key format',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Text(
              maskedKey,
              style: AppTheme.getMonospaceStyle(
                isLight: Theme.of(context).brightness == Brightness.light,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _maskApiKey(String key) {
    if (key.length <= 8) return key;

    final start = key.substring(0, 4);
    final end = key.substring(key.length - 4);
    final middle = '•' * (key.length - 8);

    return '$start$middle$end';
  }
}
