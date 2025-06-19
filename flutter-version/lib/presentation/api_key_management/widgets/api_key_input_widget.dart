import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ApiKeyInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isObscured;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onPaste;
  final Map<String, dynamic> provider;

  const ApiKeyInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isObscured,
    required this.onVisibilityToggle,
    required this.onPaste,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'API Key',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: isObscured,
            style: AppTheme.getMonospaceStyle(
              isLight: Theme.of(context).brightness == Brightness.light,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText:
                  'Enter your ${provider['name']} API key (${provider['keyFormat']})',
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onPaste,
                    icon: CustomIconWidget(
                      iconName: 'content_paste',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    tooltip: 'Paste from clipboard',
                  ),
                  IconButton(
                    onPressed: onVisibilityToggle,
                    icon: CustomIconWidget(
                      iconName: isObscured ? 'visibility' : 'visibility_off',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    tooltip: isObscured ? 'Show API key' : 'Hide API key',
                  ),
                ],
              ),
              counterText: '${controller.text.length} characters',
              counterStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')), // No spaces
            ],
            onChanged: (value) {
              // Trigger validation through parent widget
            },
          ),
        ),
      ],
    );
  }
}
