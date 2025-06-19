# ChatFuse - Native Mobile AI Chat App

ChatFuse is a minimalist mobile application that allows users to chat with various AI models from different providers. Built with Next.js and Capacitor for native iOS and Android deployment.

## Features

- **Multi-Provider Support**: OpenAI, Anthropic, Google, xAI, and Groq
- **Custom API Keys**: Secure local storage of your own API keys
- **Real-time Streaming**: Live responses with typing indicators
- **Chat History**: Local storage with offline access
- **Dark Mode**: System-aware theme switching
- **Native Features**: Haptic feedback, status bar styling, keyboard handling

## Development Setup

### Prerequisites

- Node.js 18+ and npm/pnpm
- For iOS development: Xcode and iOS Simulator
- For Android development: Android Studio and Android SDK

### Installation

1. Clone the repository:
\`\`\`bash
git clone <repository-url>
cd chatfuse
\`\`\`

2. Install dependencies:
\`\`\`bash
npm install
\`\`\`

3. Run the development server:
\`\`\`bash
npm run dev
\`\`\`

## Native App Development

### Building for Mobile

1. Build the web app:
\`\`\`bash
npm run build:mobile
\`\`\`

2. Add native platforms (first time only):
\`\`\`bash
npx cap add ios
npx cap add android
\`\`\`

### iOS Development

1. Open iOS project:
\`\`\`bash
npm run ios
\`\`\`

2. In Xcode:
   - Configure signing & capabilities
   - Set deployment target (iOS 13.0+)
   - Add app icons and launch screens
   - Build and run on simulator or device

### Android Development

1. Open Android project:
\`\`\`bash
npm run android
\`\`\`

2. In Android Studio:
   - Configure app signing
   - Set minimum SDK version (API 22+)
   - Add app icons and splash screens
   - Build and run on emulator or device

## Native Features

### Status Bar
- Automatically adapts to light/dark theme
- Proper styling for notched devices

### Haptic Feedback
- Light haptic feedback on button presses
- Enhanced user experience on supported devices

### Keyboard Handling
- Automatic resize when keyboard appears
- Smooth animations and transitions

### Share Functionality
- Native share sheet integration
- Fallback to Web Share API on web

## App Store Deployment

### iOS App Store

1. Configure app in Xcode:
   - Set bundle identifier
   - Configure signing certificates
   - Add app icons (all required sizes)
   - Set launch screens

2. Build for release:
   - Archive the app in Xcode
   - Upload to App Store Connect
   - Submit for review

### Google Play Store

1. Configure app in Android Studio:
   - Set application ID
   - Configure signing key
   - Add app icons and screenshots
   - Set version codes

2. Build release APK/AAB:
   - Generate signed bundle
   - Upload to Google Play Console
   - Submit for review

## Configuration

### App Icons
Place app icons in the following directories:
- iOS: \`ios/App/App/Assets.xcassets/AppIcon.appiconset/\`
- Android: \`android/app/src/main/res/\` (various \`mipmap-*\` folders)

### Splash Screens
Configure splash screens in:
- iOS: \`ios/App/App/Assets.xcassets/Splash.imageset/\`
- Android: \`android/app/src/main/res/drawable/\`

### App Metadata
Update app information in:
- \`capacitor.config.ts\` - App ID and name
- \`package.json\` - Version and description
- Platform-specific files for store listings

## Troubleshooting

### Common Issues

1. **Build Errors**: Ensure all dependencies are installed and platforms are synced
2. **API Keys**: Make sure to add your AI provider API keys in the settings
3. **Network Issues**: Check CORS settings for web deployment
4. **Native Permissions**: Configure required permissions in platform manifests

### Debugging

- Use Chrome DevTools for web debugging
- Use Safari Web Inspector for iOS debugging
- Use Chrome DevTools for Android debugging
- Check native logs in Xcode/Android Studio

## License

This project is licensed under the MIT License.
