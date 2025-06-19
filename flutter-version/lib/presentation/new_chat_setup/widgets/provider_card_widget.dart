import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProviderCardWidget extends StatelessWidget {
  final Map<String, dynamic> provider;
  final bool isSelected;
  final VoidCallback onTap;

  const ProviderCardWidget({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasApiKey = provider['hasApiKey'] as bool;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: provider['logo'] as String,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                if (!hasApiKey)
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'warning',
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              provider['name'] as String,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (!hasApiKey) ...[
              SizedBox(height: 0.5.h),
              Text(
                'Setup Required',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 8.sp,
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
