import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/chat_interface/chat_interface.dart';
import '../presentation/settings/settings.dart';
import '../presentation/new_chat_setup/new_chat_setup.dart';
import '../presentation/chat_list_home/chat_list_home.dart';
import '../presentation/api_key_management/api_key_management.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String chatListHome = '/chat-list-home';
  static const String chatInterface = '/chat-interface';
  static const String newChatSetup = '/new-chat-setup';
  static const String settings = '/settings';
  static const String apiKeyManagement = '/api-key-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    onboardingFlow: (context) => const OnboardingFlow(),
    chatListHome: (context) => const ChatListHome(),
    chatInterface: (context) => const ChatInterface(),
    newChatSetup: (context) => const NewChatSetup(),
    settings: (context) => const Settings(),
    apiKeyManagement: (context) => const ApiKeyManagement(),
  };
}
