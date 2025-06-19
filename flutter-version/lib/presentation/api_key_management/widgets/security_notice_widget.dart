import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityNoticeWidget extends StatelessWidget {
  const SecurityNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.successColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Security & Privacy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSecurityPoint(
            context,
            'Local Encryption',
            'Your API keys are encrypted and stored locally on your device using industry-standard encryption.',
          ),
          SizedBox(height: 1.5.h),
          _buildSecurityPoint(
            context,
            'No Cloud Storage',
            'API keys are never transmitted to our servers or stored in the cloud.',
          ),
          SizedBox(height: 1.5.h),
          _buildSecurityPoint(
            context,
            'Secure Communication',
            'All API calls use HTTPS encryption for secure communication with AI providers.',
          ),
          SizedBox(height: 1.5.h),
          _buildSecurityPoint(
            context,
            'Screenshot Protection',
            'Screenshots are automatically disabled during API key entry for additional security.',
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityPoint(
      BuildContext context, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 0.5.h),
          child: CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.successColor,
            size: 16,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successColor,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
