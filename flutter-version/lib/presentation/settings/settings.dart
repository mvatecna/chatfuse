import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/api_key_provider_widget.dart';
import './widgets/app_info_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkMode = false;
  bool isHapticFeedback = true;
  bool isAutoSave = true;
  bool isBiometricAuth = false;
  bool isDebugMode = false;
  String selectedProvider = 'OpenAI';
  String selectedModel = 'GPT-4';
  String retentionPeriod = '30 days';

  final List<Map<String, dynamic>> apiProviders = [
    {
      'name': 'OpenAI',
      'isConfigured': true,
      'keyPreview': '••••••••sk-1234',
      'icon': 'api',
    },
    {
      'name': 'Anthropic',
      'isConfigured': false,
      'keyPreview': '',
      'icon': 'psychology',
    },
    {
      'name': 'Mistral',
      'isConfigured': true,
      'keyPreview': '••••••••ms-5678',
      'icon': 'memory',
    },
    {
      'name': 'Cohere',
      'isConfigured': false,
      'keyPreview': '',
      'icon': 'hub',
    },
    {
      'name': 'Groq',
      'isConfigured': false,
      'keyPreview': '',
      'icon': 'speed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Info Section
              AppInfoWidget(),

              SizedBox(height: 3.h),

              // API Keys Section
              SettingsSectionWidget(
                title: 'API Keys',
                children: [
                  ...apiProviders.map((provider) => ApiKeyProviderWidget(
                        providerName: provider['name'],
                        isConfigured: provider['isConfigured'],
                        keyPreview: provider['keyPreview'],
                        iconName: provider['icon'],
                        onTap: () => _showApiKeyModal(provider['name']),
                      )),
                ],
              ),

              SizedBox(height: 3.h),

              // App Preferences Section
              SettingsSectionWidget(
                title: 'App Preferences',
                children: [
                  SettingsItemWidget(
                    title: 'Default Provider',
                    subtitle: selectedProvider,
                    iconName: 'business',
                    onTap: () => _showProviderSelector(),
                    showArrow: true,
                  ),
                  SettingsItemWidget(
                    title: 'Default Model',
                    subtitle: selectedModel,
                    iconName: 'model_training',
                    onTap: () => _showModelSelector(),
                    showArrow: true,
                  ),
                  SettingsItemWidget(
                    title: 'Dark Mode',
                    subtitle: 'Automatic based on system',
                    iconName: 'dark_mode',
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    title: 'Haptic Feedback',
                    subtitle: 'Vibration for interactions',
                    iconName: 'vibration',
                    trailing: Switch(
                      value: isHapticFeedback,
                      onChanged: (value) {
                        setState(() {
                          isHapticFeedback = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Chat Settings Section
              SettingsSectionWidget(
                title: 'Chat Settings',
                children: [
                  SettingsItemWidget(
                    title: 'Auto-save Conversations',
                    subtitle: 'Automatically save chat history',
                    iconName: 'save',
                    trailing: Switch(
                      value: isAutoSave,
                      onChanged: (value) {
                        setState(() {
                          isAutoSave = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    title: 'Message History',
                    subtitle: 'Keep for $retentionPeriod',
                    iconName: 'history',
                    onTap: () => _showRetentionPicker(),
                    showArrow: true,
                  ),
                  SettingsItemWidget(
                    title: 'Export Data',
                    subtitle: 'Export chat history and settings',
                    iconName: 'file_download',
                    onTap: () => _exportData(),
                    showArrow: true,
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Security Section
              SettingsSectionWidget(
                title: 'Security',
                children: [
                  SettingsItemWidget(
                    title: 'Biometric Authentication',
                    subtitle: 'Use Face ID / Fingerprint',
                    iconName: 'fingerprint',
                    trailing: Switch(
                      value: isBiometricAuth,
                      onChanged: (value) {
                        setState(() {
                          isBiometricAuth = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Advanced Section
              SettingsSectionWidget(
                title: 'Advanced',
                children: [
                  SettingsItemWidget(
                    title: 'Clear Cache',
                    subtitle: 'Free up storage space',
                    iconName: 'cleaning_services',
                    onTap: () => _showClearCacheDialog(),
                    showArrow: true,
                  ),
                  SettingsItemWidget(
                    title: 'Reset App Data',
                    subtitle: 'Clear all data and settings',
                    iconName: 'restore',
                    onTap: () => _showResetDialog(),
                    showArrow: true,
                    isDestructive: true,
                  ),
                  SettingsItemWidget(
                    title: 'Debug Mode',
                    subtitle: 'Enable developer options',
                    iconName: 'bug_report',
                    trailing: Switch(
                      value: isDebugMode,
                      onChanged: (value) {
                        setState(() {
                          isDebugMode = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Support Section
              SettingsSectionWidget(
                title: 'Support',
                children: [
                  SettingsItemWidget(
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy policy',
                    iconName: 'privacy_tip',
                    onTap: () => _openPrivacyPolicy(),
                    showArrow: true,
                  ),
                  SettingsItemWidget(
                    title: 'Contact Support',
                    subtitle: 'Get help and support',
                    iconName: 'support_agent',
                    onTap: () => _contactSupport(),
                    showArrow: true,
                  ),
                ],
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showApiKeyModal(String providerName) {
    Navigator.pushNamed(context, '/api-key-management');
  }

  void _showProviderSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Default Provider',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...['OpenAI', 'Anthropic', 'Mistral', 'Cohere', 'Groq'].map(
              (provider) => ListTile(
                title: Text(provider),
                trailing: selectedProvider == provider
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.primaryLight,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    selectedProvider = provider;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showModelSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Default Model',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...[
              'GPT-4',
              'GPT-3.5 Turbo',
              'Claude-3',
              'Mistral Large',
              'Command R+'
            ].map(
              (model) => ListTile(
                title: Text(model),
                trailing: selectedModel == model
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.primaryLight,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    selectedModel = model;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showRetentionPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message History Retention',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...['7 days', '30 days', '90 days', '1 year', 'Forever'].map(
              (period) => ListTile(
                title: Text(period),
                trailing: retentionPeriod == period
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.primaryLight,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    retentionPeriod = period;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
            'This will clear all cached data and free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset App Data'),
        content: Text(
            'This will permanently delete all your data, settings, and API keys. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('App data reset successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening privacy policy...')),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening support contact...')),
    );
  }
}
