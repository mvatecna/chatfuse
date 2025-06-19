import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/model_selector_widget.dart';
import './widgets/provider_card_widget.dart';

class NewChatSetup extends StatefulWidget {
  const NewChatSetup({super.key});

  @override
  State<NewChatSetup> createState() => _NewChatSetupState();
}

class _NewChatSetupState extends State<NewChatSetup> {
  String? selectedProvider;
  String? selectedModel;
  bool showAdvancedOptions = false;
  double temperature = 0.7;
  int maxTokens = 2048;
  String systemPrompt = '';

  final List<Map<String, dynamic>> providers = [
    {
      'id': 'openai',
      'name': 'OpenAI',
      'logo':
          'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/openai/openai-original.svg',
      'hasApiKey': true,
      'models': [
        {
          'id': 'gpt-4',
          'name': 'GPT-4',
          'description': 'Most capable model',
          'multimodal': true,
          'contextLength': '8K'
        },
        {
          'id': 'gpt-3.5-turbo',
          'name': 'GPT-3.5 Turbo',
          'description': 'Fast and efficient',
          'multimodal': false,
          'contextLength': '4K'
        },
      ]
    },
    {
      'id': 'anthropic',
      'name': 'Anthropic',
      'logo':
          'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/anthropic/anthropic-original.svg',
      'hasApiKey': false,
      'models': [
        {
          'id': 'claude-3',
          'name': 'Claude 3',
          'description': 'Advanced reasoning',
          'multimodal': true,
          'contextLength': '100K'
        },
        {
          'id': 'claude-2',
          'name': 'Claude 2',
          'description': 'Reliable assistant',
          'multimodal': false,
          'contextLength': '100K'
        },
      ]
    },
    {
      'id': 'mistral',
      'name': 'Mistral',
      'logo':
          'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=100&h=100&fit=crop&crop=center',
      'hasApiKey': true,
      'models': [
        {
          'id': 'mistral-large',
          'name': 'Mistral Large',
          'description': 'High performance',
          'multimodal': false,
          'contextLength': '32K'
        },
        {
          'id': 'mistral-medium',
          'name': 'Mistral Medium',
          'description': 'Balanced model',
          'multimodal': false,
          'contextLength': '32K'
        },
      ]
    },
    {
      'id': 'cohere',
      'name': 'Cohere',
      'logo':
          'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=100&h=100&fit=crop&crop=center',
      'hasApiKey': false,
      'models': [
        {
          'id': 'command',
          'name': 'Command',
          'description': 'Instruction following',
          'multimodal': false,
          'contextLength': '4K'
        },
        {
          'id': 'command-light',
          'name': 'Command Light',
          'description': 'Faster responses',
          'multimodal': false,
          'contextLength': '4K'
        },
      ]
    },
    {
      'id': 'groq',
      'name': 'Groq',
      'logo':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=100&h=100&fit=crop&crop=center',
      'hasApiKey': true,
      'models': [
        {
          'id': 'llama-2-70b',
          'name': 'Llama 2 70B',
          'description': 'Open source model',
          'multimodal': false,
          'contextLength': '4K'
        },
        {
          'id': 'mixtral-8x7b',
          'name': 'Mixtral 8x7B',
          'description': 'Mixture of experts',
          'multimodal': false,
          'contextLength': '32K'
        },
      ]
    },
  ];

  List<Map<String, dynamic>> get availableModels {
    if (selectedProvider == null) return [];
    final provider = providers.firstWhere((p) => p['id'] == selectedProvider);
    return (provider['models'] as List).cast<Map<String, dynamic>>();
  }

  bool get canStartChat => selectedProvider != null && selectedModel != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProviderSelection(),
                    SizedBox(height: 3.h),
                    if (selectedProvider != null) ...[
                      ModelSelectorWidget(
                        models: availableModels,
                        selectedModel: selectedModel,
                        onModelSelected: (model) {
                          setState(() {
                            selectedModel = model;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                      AdvancedOptionsWidget(
                        showAdvancedOptions: showAdvancedOptions,
                        temperature: temperature,
                        maxTokens: maxTokens,
                        systemPrompt: systemPrompt,
                        onToggleAdvanced: () {
                          setState(() {
                            showAdvancedOptions = !showAdvancedOptions;
                          });
                        },
                        onTemperatureChanged: (value) {
                          setState(() {
                            temperature = value;
                          });
                        },
                        onMaxTokensChanged: (value) {
                          setState(() {
                            maxTokens = value;
                          });
                        },
                        onSystemPromptChanged: (value) {
                          setState(() {
                            systemPrompt = value;
                          });
                        },
                      ),
                    ],
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'New Chat',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select AI Provider',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: providers.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final provider = providers[index];
              return ProviderCardWidget(
                provider: provider,
                isSelected: selectedProvider == provider['id'],
                onTap: () {
                  if (provider['hasApiKey'] as bool) {
                    setState(() {
                      selectedProvider = provider['id'] as String;
                      selectedModel = null; // Reset model selection
                    });
                  } else {
                    _showApiKeyRequiredDialog(provider['name'] as String);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canStartChat ? _startChat : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: canStartChat
                    ? AppTheme.lightTheme.primaryColor
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.12),
                foregroundColor: canStartChat
                    ? Colors.white
                    : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.38),
              ),
              child: Text(
                'Start Chat',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: _useDefaultSettings,
            child: Text(
              'Use Default Settings',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApiKeyRequiredDialog(String providerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('API Key Required'),
        content: Text(
            '$providerName requires an API key to use. Would you like to set it up now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/api-key-management');
            },
            child: Text('Setup API Key'),
          ),
        ],
      ),
    );
  }

  void _startChat() {
    if (canStartChat) {
      Navigator.pushNamed(context, '/chat-interface');
    }
  }

  void _useDefaultSettings() {
    setState(() {
      selectedProvider = 'openai';
      selectedModel = 'gpt-3.5-turbo';
      temperature = 0.7;
      maxTokens = 2048;
      systemPrompt = '';
      showAdvancedOptions = false;
    });
  }
}
