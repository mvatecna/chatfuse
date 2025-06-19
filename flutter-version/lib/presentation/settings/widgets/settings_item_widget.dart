import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showArrow;
  final bool isDestructive;

  const SettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconName,
    this.onTap,
    this.trailing,
    this.showArrow = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.errorColor.withValues(alpha: 0.1)
              : AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: isDestructive ? AppTheme.errorColor : AppTheme.primaryLight,
            size: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDestructive
                  ? AppTheme.errorColor
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          : null,
      trailing: trailing ??
          (showArrow
              ? CustomIconWidget(
                  iconName: 'chevron_right',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                )
              : null),
      onTap: onTap,
    );
  }
}
