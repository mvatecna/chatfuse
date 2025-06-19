import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MessageInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isLoading;

  const MessageInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  bool _hasText = false;
  int _maxLines = 1;
  final int _maxInputLines = 6;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    final hasText = text.trim().isNotEmpty;
    final lines = text.split('\n').length;
    final calculatedLines = lines.clamp(1, _maxInputLines);

    if (hasText != _hasText || calculatedLines != _maxLines) {
      setState(() {
        _hasText = hasText;
        _maxLines = calculatedLines;
      });
    }
  }

  void _handleSend() {
    if (_hasText && !widget.isLoading) {
      HapticFeedback.lightImpact();
      widget.onSend();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button
              Container(
                width: 10.w,
                height: 10.w,
                margin: EdgeInsets.only(right: 2.w, bottom: 0.5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: IconButton(
                  icon: CustomIconWidget(
                    iconName: 'attach_file',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showAttachmentOptions();
                  },
                ),
              ),

              // Text input field
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 6.h,
                    maxHeight: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6.w),
                    border: Border.all(
                      color: widget.focusNode.hasFocus
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: _maxLines,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // Send/Voice button
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: _hasText || widget.isLoading
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: widget.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        icon: CustomIconWidget(
                          iconName: _hasText ? 'send' : 'mic',
                          color: _hasText
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: _hasText ? _handleSend : _startVoiceInput,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      context,
                      'camera',
                      'Camera',
                      () {
                        Navigator.pop(context);
                        // Implement camera functionality
                      },
                    ),
                    _buildAttachmentOption(
                      context,
                      'photo_library',
                      'Gallery',
                      () {
                        Navigator.pop(context);
                        // Implement gallery functionality
                      },
                    ),
                    _buildAttachmentOption(
                      context,
                      'insert_drive_file',
                      'Document',
                      () {
                        Navigator.pop(context);
                        // Implement document picker
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context,
    String iconName,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(7.5.w),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  void _startVoiceInput() {
    HapticFeedback.mediumImpact();
    // Implement voice input functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice input feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
