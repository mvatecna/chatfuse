import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ModelSelectorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> models;
  final String? selectedModel;
  final Function(String) onModelSelected;

  const ModelSelectorWidget({
    super.key,
    required this.models,
    required this.selectedModel,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Model',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedModel,
              hint: Text(
                'Choose a model',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              items: models.map((model) {
                return DropdownMenuItem<String>(
                  value: model['id'] as String,
                  child: _buildModelItem(context, model),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onModelSelected(value);
                }
              },
            ),
          ),
        ),
        if (selectedModel != null) ...[
          SizedBox(height: 2.h),
          _buildModelDetails(context),
        ],
      ],
    );
  }

  Widget _buildModelItem(BuildContext context, Map<String, dynamic> model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          model['name'] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          model['description'] as String,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildModelDetails(BuildContext context) {
    final selectedModelData = models.firstWhere(
      (model) => model['id'] == selectedModel,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Model Details',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              _buildCapabilityChip(
                context,
                selectedModelData['multimodal'] as bool
                    ? 'Multimodal'
                    : 'Text Only',
                selectedModelData['multimodal'] as bool
                    ? AppTheme.successColor
                    : AppTheme.warningColor,
              ),
              SizedBox(width: 2.w),
              _buildCapabilityChip(
                context,
                '${selectedModelData['contextLength']} Context',
                AppTheme.lightTheme.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            selectedModelData['description'] as String,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityChip(BuildContext context, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
