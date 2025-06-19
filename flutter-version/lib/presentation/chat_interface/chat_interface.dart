import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatInterface extends StatefulWidget {
  const ChatInterface({super.key});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  bool _isTyping = false;
  bool _isLoading = false;
  String _currentProvider = 'OpenAI';
  String _currentModel = 'GPT-4';

  // Mock chat data
  final List<Map<String, dynamic>> _messages = [
    {
      "id": "1",
      "content": "Hello! I'm your AI assistant. How can I help you today?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "provider": "OpenAI",
      "model": "GPT-4",
      "tokenCount": 12,
    },
    {
      "id": "2",
      "content":
          "Can you help me understand how Flutter state management works?",
      "isUser": true,
      "timestamp": DateTime.now().subtract(Duration(minutes: 4)),
      "tokenCount": 11,
    },
    {
      "id": "3",
      "content":
          """Flutter state management is a crucial concept for building reactive applications. Here are the main approaches: **1. setState()** - Built-in method for local state **2. Provider** - Popular dependency injection and state management **3. Riverpod** - Modern evolution of Provider **4. Bloc/Cubit** - Business Logic Component pattern **5. GetX** - All-in-one solution Each has its own use cases and benefits. Would you like me to explain any specific approach in detail?""",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 3)),
      "provider": "OpenAI",
      "model": "GPT-4",
      "tokenCount": 89,
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "content": messageText,
        "isUser": true,
        "timestamp": DateTime.now(),
        "tokenCount": messageText.split(' ').length,
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _messages.add({
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "content":
              "I understand your question about \"$messageText\". Let me provide you with a detailed response that addresses your specific needs and requirements.",
          "isUser": false,
          "timestamp": DateTime.now(),
          "provider": _currentProvider,
          "model": _currentModel,
          "tokenCount": 25,
        });
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _showMessageOptions(Map<String, dynamic> message) {
    HapticFeedback.mediumImpact();
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
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'copy',
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Copy Message'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message["content"]));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Message copied to clipboard')),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
                title: Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              if (!(message["isUser"] as bool)) ...[
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'refresh',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                  title: Text('Regenerate'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement regenerate functionality
                  },
                ),
              ],
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.errorColor,
                  size: 24,
                ),
                title: Text('Delete',
                    style: TextStyle(color: AppTheme.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.removeWhere((msg) => msg["id"] == message["id"]);
                  });
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showProviderSelector() {
    final providers = [
      {
        'name': 'OpenAI',
        'models': ['GPT-4', 'GPT-3.5 Turbo']
      },
      {
        'name': 'Anthropic',
        'models': ['Claude-3 Opus', 'Claude-3 Sonnet']
      },
      {
        'name': 'Mistral',
        'models': ['Mistral Large', 'Mistral Medium']
      },
      {
        'name': 'Cohere',
        'models': ['Command R+', 'Command R']
      },
      {
        'name': 'Groq',
        'models': ['Llama 3 70B', 'Mixtral 8x7B']
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Text(
                'Select AI Provider & Model',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return ExpansionTile(
                    leading: CustomIconWidget(
                      iconName: 'smart_toy',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(provider['name'] as String),
                    children: (provider['models'] as List<String>).map((model) {
                      final isSelected = _currentProvider == provider['name'] &&
                          _currentModel == model;
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 16.w),
                        title: Text(model),
                        trailing: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _currentProvider = provider['name'] as String;
                            _currentModel = model;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshMessages() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading earlier messages
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: _showProviderSelector,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentProvider,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                _currentModel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
                case 'clear':
                  setState(() {
                    _messages.clear();
                  });
                  break;
                case 'export':
                  // Implement export functionality
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'clear_all',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Export Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMessages,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return TypingIndicatorWidget(provider: _currentProvider);
                  }

                  final message = _messages[index];
                  return GestureDetector(
                    onLongPress: () => _showMessageOptions(message),
                    child: MessageBubbleWidget(
                      message: message,
                      onSwipeUp: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Sent: ${(message["timestamp"] as DateTime).toString().substring(0, 16)} • Tokens: ${message["tokenCount"]}',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          MessageInputWidget(
            controller: _messageController,
            focusNode: _messageFocusNode,
            onSend: _sendMessage,
            isLoading: _isTyping,
          ),
        ],
      ),
    );
  }
}
