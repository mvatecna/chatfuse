import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ApiKeyProviderWidget extends StatelessWidget {
  final String providerName;
  final bool isConfigured;
  final String keyPreview;
  final String iconName;
  final VoidCallback onTap;

  const ApiKeyProviderWidget({
    super.key,
    required this.providerName,
    required this.isConfigured,
    required this.keyPreview,
    required this.iconName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.primaryLight,
            size: 20,
          ),
        ),
      ),
      title: Text(
        providerName,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: isConfigured
          ? Text(
              keyPreview,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                    fontFamily: 'monospace',
                  ),
            )
          : Text(
              'Not configured',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorColor,
                  ),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConfigured ? AppTheme.successColor : AppTheme.errorColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          isConfigured
              ? CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successColor,
                  size: 20,
                )
              : Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Add Key',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
