import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/chat_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/provider_filter_chip_widget.dart';

class ChatListHome extends StatefulWidget {
  const ChatListHome({super.key});

  @override
  State<ChatListHome> createState() => _ChatListHomeState();
}

class _ChatListHomeState extends State<ChatListHome>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  String _searchQuery = '';
  String _selectedProvider = 'All';
  bool _isRefreshing = false;

  // Mock data for chat conversations
  final List<Map<String, dynamic>> _chatData = [
    {
      "id": "1",
      "title": "Flutter Development Help",
      "lastMessage":
          "How can I implement state management in Flutter using Riverpod?",
      "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      "provider": "OpenAI",
      "providerIcon": "smart_toy",
      "isUnread": true,
      "isPinned": false,
      "isArchived": false,
      "messageCount": 12,
    },
    {
      "id": "2",
      "title": "API Integration Guide",
      "lastMessage":
          "The REST API implementation looks good. Let me help you with error handling...",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "provider": "Anthropic",
      "providerIcon": "psychology",
      "isUnread": false,
      "isPinned": true,
      "isArchived": false,
      "messageCount": 8,
    },
    {
      "id": "3",
      "title": "Database Design Discussion",
      "lastMessage":
          "For your e-commerce app, I'd recommend using a normalized database structure...",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "provider": "Mistral",
      "providerIcon": "memory",
      "isUnread": false,
      "isPinned": false,
      "isArchived": false,
      "messageCount": 24,
    },
    {
      "id": "4",
      "title": "Machine Learning Concepts",
      "lastMessage":
          "Neural networks work by processing data through interconnected layers...",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "provider": "Cohere",
      "providerIcon": "hub",
      "isUnread": false,
      "isPinned": false,
      "isArchived": false,
      "messageCount": 15,
    },
    {
      "id": "5",
      "title": "Code Review Session",
      "lastMessage":
          "Your implementation is solid, but here are some optimization suggestions...",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "provider": "Groq",
      "providerIcon": "speed",
      "isUnread": false,
      "isPinned": false,
      "isArchived": false,
      "messageCount": 6,
    },
  ];

  final List<String> _providers = [
    'All',
    'OpenAI',
    'Anthropic',
    'Mistral',
    'Cohere',
    'Groq'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredChats {
    return _chatData.where((chat) {
      final matchesSearch = _searchQuery.isEmpty ||
          (chat['title'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (chat['lastMessage'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesProvider =
          _selectedProvider == 'All' || chat['provider'] == _selectedProvider;

      return matchesSearch && matchesProvider && !chat['isArchived'];
    }).toList();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleChatTap(String chatId) {
    Navigator.pushNamed(context, '/chat-interface');
  }

  void _handleNewChat() {
    Navigator.pushNamed(context, '/new-chat-setup');
  }

  void _handleSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ChatFuse',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleSettings,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.dividerColor,
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'settings',
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              padding: EdgeInsets.all(4.w),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),

            // Provider Filter Chips
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _providers.length,
                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                itemBuilder: (context, index) {
                  return ProviderFilterChipWidget(
                    label: _providers[index],
                    isSelected: _selectedProvider == _providers[index],
                    onTap: () {
                      setState(() {
                        _selectedProvider = _providers[index];
                      });
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // Chat List
            Expanded(
              child: _filteredChats.isEmpty
                  ? EmptyStateWidget(
                      onNewChat: _handleNewChat,
                      searchQuery: _searchQuery,
                    )
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      color: theme.colorScheme.primary,
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemCount: _filteredChats.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 1.h),
                        itemBuilder: (context, index) {
                          final chat = _filteredChats[index];
                          return ChatCardWidget(
                            chatData: chat,
                            onTap: () => _handleChatTap(chat['id']),
                            onPin: () {
                              setState(() {
                                chat['isPinned'] = !chat['isPinned'];
                              });
                            },
                            onArchive: () {
                              setState(() {
                                chat['isArchived'] = true;
                              });
                            },
                            onDelete: () {
                              setState(() {
                                _chatData.removeWhere(
                                    (item) => item['id'] == chat['id']);
                              });
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNewChat,
        child: CustomIconWidget(
          iconName: 'add',
          color:
              theme.floatingActionButtonTheme.foregroundColor ?? Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
