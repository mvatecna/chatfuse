# ChatFuse 🚀

A powerful multi-platform AI chat application that allows you to interact with multiple AI providers and models from a single unified interface. Available on mobile (iOS/Android), web, and desktop platforms.

## ✨ Features

### Core Features

- **Multi-Provider Support**: Integrate with multiple AI providers including:

  - OpenAI (GPT-4o, GPT-4 Turbo, GPT-3.5 Turbo)
  - Anthropic (Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku)
  - Google (Gemini 1.5 Pro, Gemini 1.5 Flash)
  - xAI (Grok 3, Grok 2)
  - Groq (Llama 3.3 70B, Llama 3.1 8B, Mixtral 8x7B)
  - Local Models (Llama 3.2 3B, Phi 3.5 Mini, Qwen 2.5, Gemma 2)

- **Secure API Key Management**: Store and manage API keys securely across all platforms
- **Chat History**: Persistent chat sessions with search and organization
- **Model Switching**: Switch between different AI models within the same conversation
- **Dark/Light Theme**: Adaptive theming across all platforms
- **Responsive Design**: Optimized for all screen sizes

### Platform-Specific Features

- **Mobile**: Native iOS and Android apps with offline capabilities
- **Web**: Progressive Web App (PWA) with local model support
- **Desktop**: Cross-platform desktop app via Capacitor

## 🏗️ Project Structure

This repository contains three complete implementations of ChatFuse:

```
chatfuse/
├── expo-version/          # React Native + Expo (iOS/Android)
├── flutter-version/       # Flutter (iOS/Android/Web/Desktop)
└── nextjs-version/        # Next.js + React (Web/PWA/Desktop via Capacitor)
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and pnpm (for Expo and Next.js versions)
- Flutter SDK 3.6+ (for Flutter version)
- iOS: Xcode 14+ and iOS Simulator
- Android: Android Studio and Android SDK

### Expo Version (React Native)

```bash
cd expo-version
pnpm install
pnpm start

# Run on specific platforms
pnpm ios      # iOS Simulator
pnpm android  # Android Emulator
pnpm web      # Web browser
```

### Flutter Version

```bash
cd flutter-version
flutter pub get
flutter run

# Build for specific platforms
flutter build apk           # Android APK
flutter build ios           # iOS
flutter build web           # Web
flutter build macos         # macOS
flutter build windows       # Windows
flutter build linux         # Linux
```

### Next.js Version

```bash
cd nextjs-version
pnpm install
pnpm dev      # Development server

# Build and deploy
pnpm build
pnpm start    # Production server
```

## 🔧 Configuration

### API Keys Setup

Each version provides a secure way to manage API keys:

1. **OpenAI**: Get your API key from [platform.openai.com](https://platform.openai.com)
2. **Anthropic**: Get your API key from [console.anthropic.com](https://console.anthropic.com)
3. **Google**: Get your API key from [aistudio.google.com](https://aistudio.google.com)
4. **xAI**: Get your API key from [console.x.ai](https://console.x.ai)
5. **Groq**: Get your API key from [console.groq.com](https://console.groq.com)

### Environment Variables (Next.js version)

Create a `.env.local` file in the `nextjs-version` directory:

```env
# Optional: Pre-configure API keys (not recommended for production)
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
GOOGLE_GENERATIVE_AI_API_KEY=your_google_key_here
XAI_API_KEY=your_xai_key_here
GROQ_API_KEY=your_groq_key_here
```

## 🛠️ Technology Stack

### Expo Version

- **Framework**: React Native with Expo
- **Navigation**: Expo Router
- **State Management**: Zustand
- **Styling**: NativeWind (Tailwind CSS for React Native)
- **Storage**: AsyncStorage + Expo SecureStore
- **Icons**: Lucide React Native

### Flutter Version

- **Framework**: Flutter 3.6+
- **State Management**: Provider pattern
- **Storage**: SharedPreferences + FlutterSecureStorage
- **Network**: Dio HTTP client
- **UI**: Material Design 3
- **Charts**: FL Chart

### Next.js Version

- **Framework**: Next.js 15 with App Router
- **UI Library**: Radix UI + Tailwind CSS
- **AI Integration**: Vercel AI SDK
- **Local Models**: WebLLM (MLC)
- **State Management**: React hooks + Context
- **Mobile**: Capacitor for native app builds
- **Styling**: Tailwind CSS + Shadcn/ui

## 📱 Platform Support

| Platform | Expo | Flutter | Next.js            |
| -------- | ---- | ------- | ------------------ |
| iOS      | ✅   | ✅      | ✅ (via Capacitor) |
| Android  | ✅   | ✅      | ✅ (via Capacitor) |
| Web      | ✅   | ✅      | ✅                 |
| macOS    | ❌   | ✅      | ✅ (via Capacitor) |
| Windows  | ❌   | ✅      | ✅ (via Capacitor) |
| Linux    | ❌   | ✅      | ❌                 |

## 🔒 Security & Privacy

- **Local Storage**: API keys are stored securely using platform-specific secure storage
- **No Data Collection**: All conversations remain on your device
- **Open Source**: Full transparency with open-source code
- **Local Models**: Option to run AI models entirely offline

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with ❤️ using React Native, Flutter, and Next.js
- UI components from Radix UI and Expo
- AI integrations powered by Vercel AI SDK
- Local model support via WebLLM and MLC

## 📞 Support

- 🐛 **Bug Reports**: [Open an issue](https://github.com/maxvyr/chatfuse/issues)
- 💡 **Feature Requests**: [Start a discussion](https://github.com/maxvyr/chatfuse/discussions)
- 📧 **Contact**: maximevidalinc@gmail.com

---

Made with ❤️ by [Maxime Vidalinc](https://x.com/maxvidalinc)
