import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsWidget extends StatelessWidget {
  final bool showAdvancedOptions;
  final double temperature;
  final int maxTokens;
  final String systemPrompt;
  final VoidCallback onToggleAdvanced;
  final Function(double) onTemperatureChanged;
  final Function(int) onMaxTokensChanged;
  final Function(String) onSystemPromptChanged;

  const AdvancedOptionsWidget({
    super.key,
    required this.showAdvancedOptions,
    required this.temperature,
    required this.maxTokens,
    required this.systemPrompt,
    required this.onToggleAdvanced,
    required this.onTemperatureChanged,
    required this.onMaxTokensChanged,
    required this.onSystemPromptChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggleAdvanced,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Advanced Options',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                CustomIconWidget(
                  iconName: showAdvancedOptions ? 'expand_less' : 'expand_more',
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (showAdvancedOptions) ...[
          SizedBox(height: 2.h),
          _buildAdvancedContent(context),
        ],
      ],
    );
  }

  Widget _buildAdvancedContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTemperatureSlider(context),
          SizedBox(height: 3.h),
          _buildMaxTokensInput(context),
          SizedBox(height: 3.h),
          _buildSystemPromptInput(context),
        ],
      ),
    );
  }

  Widget _buildTemperatureSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Temperature',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                temperature.toStringAsFixed(1),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: temperature,
            min: 0.0,
            max: 2.0,
            divisions: 20,
            onChanged: onTemperatureChanged,
          ),
        ),
        Text(
          'Controls randomness: 0 = focused, 2 = creative',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildMaxTokensInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max Tokens',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: maxTokens.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter max tokens (e.g., 2048)',
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
          onChanged: (value) {
            final tokens = int.tryParse(value);
            if (tokens != null && tokens > 0) {
              onMaxTokensChanged(tokens);
            }
          },
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Maximum length of the response',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildSystemPromptInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Prompt',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: systemPrompt,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'You are a helpful assistant that...',
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            alignLabelWithHint: true,
          ),
          onChanged: onSystemPromptChanged,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Instructions for how the AI should behave',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}
