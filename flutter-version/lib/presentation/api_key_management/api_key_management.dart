import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/api_key_input_widget.dart';
import './widgets/provider_header_widget.dart';
import './widgets/provider_help_widget.dart';
import './widgets/security_notice_widget.dart';
import './widgets/test_connection_widget.dart';
import './widgets/validation_status_widget.dart';

class ApiKeyManagement extends StatefulWidget {
  const ApiKeyManagement({super.key});

  @override
  State<ApiKeyManagement> createState() => _ApiKeyManagementState();
}

class _ApiKeyManagementState extends State<ApiKeyManagement> {
  final TextEditingController _apiKeyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isObscured = true;
  bool _isValidating = false;
  bool _isTestingConnection = false;
  bool _hasExistingKey = false;
  String _validationStatus = 'empty'; // empty, invalid, valid
  String _selectedProvider = 'OpenAI';

  // Mock data for providers
  final List<Map<String, dynamic>> _providers = [
    {
      'name': 'OpenAI',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/ChatGPT_logo.svg/1024px-ChatGPT_logo.svg.png',
      'description': 'Access to GPT models for chat and completion',
      'pricing': 'Pay-per-use pricing starting at \$0.002/1K tokens',
      'helpUrl': 'https://platform.openai.com/api-keys',
      'keyFormat': 'sk-...',
    },
    {
      'name': 'Anthropic',
      'logo':
          'https://pbs.twimg.com/profile_images/1692935922432770048/8b7jdsGb_400x400.jpg',
      'description': 'Claude AI models for advanced reasoning',
      'pricing': 'Usage-based pricing from \$0.25/1M tokens',
      'helpUrl': 'https://console.anthropic.com/settings/keys',
      'keyFormat': 'sk-ant-...',
    },
    {
      'name': 'Mistral',
      'logo':
          'https://mistral.ai/images/logo_hubc88c4ece131b91c7cb753f40e9e1cc5_2589_256x0_resize_q75_h2_lanczos_3.webp',
      'description': 'Open-source and commercial AI models',
      'pricing': 'Competitive pricing starting at \$0.14/1M tokens',
      'helpUrl': 'https://console.mistral.ai/api-keys/',
      'keyFormat': 'api_key_...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _apiKeyController.addListener(_onApiKeyChanged);
    _loadExistingKey();
  }

  @override
  void dispose() {
    _apiKeyController.removeListener(_onApiKeyChanged);
    _apiKeyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadExistingKey() {
    // Mock loading existing key
    setState(() {
      _hasExistingKey = false; // Set to true if key exists
    });
  }

  void _onApiKeyChanged() {
    if (_apiKeyController.text.isEmpty) {
      setState(() {
        _validationStatus = 'empty';
      });
    } else {
      _validateApiKey();
    }
  }

  void _validateApiKey() {
    setState(() {
      _isValidating = true;
    });

    // Mock validation logic
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final key = _apiKeyController.text;
        final provider =
            _providers.firstWhere((p) => p['name'] == _selectedProvider);
        final expectedFormat = provider['keyFormat'] as String;

        bool isValid = false;
        if (_selectedProvider == 'OpenAI' &&
            key.startsWith('sk-') &&
            key.length > 20) {
          isValid = true;
        } else if (_selectedProvider == 'Anthropic' &&
            key.startsWith('sk-ant-') &&
            key.length > 20) {
          isValid = true;
        } else if (_selectedProvider == 'Mistral' &&
            key.startsWith('api_key_') &&
            key.length > 20) {
          isValid = true;
        }

        setState(() {
          _validationStatus = isValid ? 'valid' : 'invalid';
          _isValidating = false;
        });
      }
    });
  }

  void _testConnection() async {
    setState(() {
      _isTestingConnection = true;
    });

    // Mock API test
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isTestingConnection = false;
      });

      // Mock success/failure
      final isSuccess = DateTime.now().millisecond % 2 == 0;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSuccess
                ? 'Connection successful! API key is valid.'
                : 'Connection failed. Please check your API key.',
          ),
          backgroundColor:
              isSuccess ? AppTheme.successColor : AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _saveApiKey() async {
    if (_validationStatus != 'valid') return;

    // Mock save operation
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API key saved successfully'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _deleteApiKey() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete API Key'),
        content: Text(
            'Are you sure you want to delete the API key for $_selectedProvider? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _apiKeyController.clear();
                _hasExistingKey = false;
                _validationStatus = 'empty';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('API key deleted'),
                  backgroundColor: AppTheme.warningColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      _apiKeyController.text = clipboardData!.text!;
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProvider =
        _providers.firstWhere((p) => p['name'] == _selectedProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('API Key Management'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _validationStatus == 'valid' ? _saveApiKey : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _validationStatus == 'valid'
                    ? AppTheme.primaryLight
                    : Theme.of(context).disabledColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider Selection Dropdown
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
                    value: _selectedProvider,
                    isExpanded: true,
                    icon: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                    items: _providers.map((provider) {
                      return DropdownMenuItem<String>(
                        value: provider['name'] as String,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CustomImageWidget(
                                imageUrl: provider['logo'] as String,
                                width: 24,
                                height: 24,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider['name'] as String,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedProvider = value;
                          _apiKeyController.clear();
                          _validationStatus = 'empty';
                        });
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Provider Header
              ProviderHeaderWidget(
                provider: currentProvider,
              ),

              SizedBox(height: 3.h),

              // API Key Input
              ApiKeyInputWidget(
                controller: _apiKeyController,
                focusNode: _focusNode,
                isObscured: _isObscured,
                onVisibilityToggle: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                onPaste: _pasteFromClipboard,
                provider: currentProvider,
              ),

              SizedBox(height: 2.h),

              // Validation Status
              ValidationStatusWidget(
                status: _validationStatus,
                isValidating: _isValidating,
                provider: currentProvider,
                apiKey: _apiKeyController.text,
              ),

              SizedBox(height: 3.h),

              // Test Connection Button
              if (_validationStatus == 'valid') ...[
                TestConnectionWidget(
                  isLoading: _isTestingConnection,
                  onTest: _testConnection,
                ),
                SizedBox(height: 3.h),
              ],

              // Security Notice
              const SecurityNoticeWidget(),

              SizedBox(height: 3.h),

              // Delete Key Button (if existing key)
              if (_hasExistingKey) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _deleteApiKey,
                    icon: CustomIconWidget(
                      iconName: 'delete_outline',
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                    label: const Text('Delete API Key'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: const BorderSide(color: AppTheme.errorColor),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],

              // Provider Help
              ProviderHelpWidget(
                provider: currentProvider,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
