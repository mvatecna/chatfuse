import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to ChatFuse",
      "subtitle": "Multi-Provider AI Chat",
      "description":
          "Connect with multiple AI providers like OpenAI, Anthropic, Mistral, and more. Experience the power of AI conversations with complete privacy and control.",
      "imageUrl":
          "https://images.unsplash.com/photo-1677442136019-21780ecad995?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "chat_bubble_outline",
      "features": [
        "Multiple AI providers in one app",
        "Fast and responsive chat interface",
        "Complete privacy and data control"
      ]
    },
    {
      "title": "Secure API Key Management",
      "subtitle": "Your Keys, Your Control",
      "description":
          "Store your API keys securely with encrypted local storage. No data leaves your device without your permission. Full transparency and security.",
      "imageUrl":
          "https://images.unsplash.com/photo-1614064641938-3bbee52942c7?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "security",
      "features": [
        "Encrypted local storage",
        "No cloud data storage",
        "Complete API key control"
      ]
    },
    {
      "title": "Intuitive Chat Experience",
      "subtitle": "Gestures & Navigation",
      "description":
          "Swipe to delete chats, long-press for options, and pull-to-refresh. Experience native mobile gestures designed for productivity and ease of use.",
      "imageUrl":
          "https://images.unsplash.com/photo-1551650975-87deedd944c3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "iconName": "touch_app",
      "features": [
        "Swipe gestures for chat management",
        "Long-press for quick actions",
        "Pull-to-refresh conversations"
      ]
    }
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/settings');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10.w),
                  Text(
                    'ChatFuse',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryLight,
                        ),
                  ),
                  GestureDetector(
                    onTap: _skipOnboarding,
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
            ),

            // Page indicator
            Container(
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentPage == index ? 8.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppTheme.primaryLight
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    data: _onboardingData[index],
                    isLastPage: index == _onboardingData.length - 1,
                  );
                },
              ),
            ),

            // Bottom navigation
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  _currentPage < _onboardingData.length - 1
                      ? TextButton(
                          onPressed: _skipOnboarding,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 1.5.h),
                          ),
                          child: Text(
                            'Skip',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        )
                      : SizedBox(width: 20.w),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 1.8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: _currentPage == _onboardingData.length - 1
                              ? 'rocket_launch'
                              : 'arrow_forward',
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
