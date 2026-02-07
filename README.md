# CareConnect Flutter

A comprehensive healthcare application built with Flutter, featuring full accessibility compliance and persistent user preferences.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode (for mobile development)

### Installation

1. **Install Flutter SDK**
   - Follow the official guide: https://docs.flutter.dev/get-started/install

2. **Clone and Setup**
   ```bash
   cd flutter
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

### Demo Credentials
- **Username**: `demo`
- **Password**: `demo123`

## ✨ Features

### Core Functionality
- ✅ **Medication Management** - Track medications with complex scheduling patterns
- ✅ **Appointment Calendar** - Interactive calendar with appointment management
- ✅ **Communications** - Quick message templates and provider contacts
- ✅ **3-Step Refill Requests** - Streamlined medication refill workflow
- ✅ **Today Dashboard** - At-a-glance view of medications and appointments

### Accessibility Features
- ✅ **Left-Hand Mode** - Optimized layout for one-handed use
- ✅ **56×56 dp Touch Targets** - WCAG compliant minimum sizes
- ✅ **Persistent Settings** - Hand preference saved to device
- ✅ **Landscape Support** - Fully responsive for all orientations
- ✅ **Screen Reader Support** - Semantic labels for assistive technologies

### Authentication
- 🔐 Biometric authentication (fingerprint/face ID)
- 🔐 Passcode login
- 🔐 Username/password authentication
- 🔐 One-time onboarding flow

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test Suite
```bash
# Widget tests
flutter test test/widget_test.dart

# Provider tests
flutter test test/provider_test.dart

# Model tests
flutter test test/model_test.dart

# Integration tests
flutter test test/integration_test.dart

# Accessibility tests
flutter test test/accessibility_test.dart
```

### Test Coverage
```bash
flutter test --coverage
```

### View Coverage Report
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## 📂 Project Structure

```
flutter/
├── lib/
│   ├── config/
│   │   ├── routes.dart          # Go Router configuration
│   │   └── theme.dart           # App theme & design tokens
│   ├── models/
│   │   ├── appointment.dart     # Appointment data model
│   │   ├── contact.dart         # Contact data model
│   │   ├── medication.dart      # Medication & action models
│   │   └── message_template.dart # Message template model
│   ├── providers/
│   │   └── app_provider.dart    # Main app state (Provider)
│   ├── screens/
│   │   ├── add_medication_screen.dart
│   │   ├── calendar_screen.dart
│   │   ├── communications_screen.dart
│   │   ├── home_screen.dart     # Bottom navigation shell
│   │   ├── login_screen.dart
│   │   ├── medication_detail_screen.dart
│   │   ├── medications_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── refill_request_screen.dart
│   │   ├── settings_screen.dart
│   │   └── today_view_screen.dart
│   └── main.dart                # App entry point
├── test/
│   ├── widget_test.dart         # UI widget tests
│   ├── provider_test.dart       # State management tests
│   ├── model_test.dart          # Data model tests
│   ├── integration_test.dart    # End-to-end flow tests
│   └── accessibility_test.dart  # WCAG compliance tests
├── pubspec.yaml                 # Dependencies
└── README.md
```

## 🎨 Design System

### Colors
- **Primary**: `#2563EB` (blue-600)
- **Primary Hover**: `#1D4ED8` (blue-700)
- **Primary Light**: `#EFF6FF` (blue-50)
- **Gray Scale**: From `#111827` to `#F9FAFB`
- **Error**: `#DC2626` (red-600)
- **Success**: `#16A34A` (green-600)
- **Warning**: `#EA580C` (orange-600)

### Touch Targets
- **Portrait**: 56×56 dp minimum
- **Landscape**: 48×48 dp minimum
- **Spacing**: 8dp base unit

### Typography
Material Design 3 with accessibility-focused sizing

## 🔧 State Management

The app uses **Provider** for state management:

```dart
// Access app state
final appProvider = Provider.of<AppProvider>(context);

// Listen to changes
final appProvider = Provider.of<AppProvider>(context, listen: true);

// No listening (for callbacks)
final appProvider = Provider.of<AppProvider>(context, listen: false);
```

### Key State
- Authentication status
- Hand preference (left/right)
- Biometric settings
- Medications list
- Appointments list
- Message templates
- Contacts

## 💾 Persistent Storage

Uses **SharedPreferences** for local storage:

### Saved Settings
- ✅ `leftHandMode` - Hand preference (bool)
- ✅ `biometricEnabled` - Biometric auth toggle (bool)
- ✅ `onboardingComplete` - Onboarding status (bool)
- ✅ `favorites` - Favorited screens (List<String>)

### How It Works
1. User selects hand preference in onboarding
2. Settings saved to device storage
3. On app restart, settings auto-load
4. User can change in Settings anytime

## 🧭 Navigation

Uses **go_router** for declarative routing:

```dart
// Navigate to a route
context.go('/medications');

// Navigate with parameters
context.go('/medications/${medicationId}');

// Go back
context.pop();
```

### Route Guards
- Redirects unauthenticated users to `/login`
- Redirects new users to `/onboarding`
- Redirects authenticated users away from login/onboarding

## ♿ Accessibility Compliance

### WCAG 2.1 Level AA
- ✅ **Perceivable**: Sufficient color contrast
- ✅ **Operable**: 56×56 dp touch targets
- ✅ **Understandable**: Clear labels and instructions
- ✅ **Robust**: Semantic markup for screen readers

### Accessibility Tests
Run comprehensive accessibility tests:
```bash
flutter test test/accessibility_test.dart
```

Tests verify:
- Touch target sizes
- Color contrast ratios
- Semantic labels
- Left-hand mode functionality
- Keyboard navigation

## 📱 Platform Support

- ✅ **iOS**: 12.0+
- ✅ **Android**: API 21+ (Android 5.0)
- ⚠️ **Web**: Not optimized
- ⚠️ **Desktop**: Not optimized

## 🔨 Build Commands

### Debug Build
```bash
flutter run
```

### Profile Build (performance testing)
```bash
flutter run --profile
```

### Release Build

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle (for Play Store)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🐛 Debugging

### Flutter DevTools
```bash
# Activate DevTools
flutter pub global activate devtools

# Run app in debug mode
flutter run

# Open DevTools (follow link in terminal)
```

### Logging
```dart
import 'dart:developer' as developer;

developer.log('Debug message', name: 'CareConnect');
```

### View Logs
```bash
flutter logs
```

## 📊 Performance

### Analyze App Size
```bash
flutter build apk --analyze-size
flutter build ios --analyze-size
```

### Performance Profiling
1. Run in profile mode: `flutter run --profile`
2. Open DevTools
3. Navigate to Performance tab
4. Record and analyze

## 🤝 Contributing

### Code Style
Follow official Dart style guide:
```bash
# Format code
flutter format .

# Analyze code
flutter analyze
```

### Before Committing
```bash
# Run tests
flutter test

# Check formatting
flutter format --set-exit-if-changed .

# Analyze
flutter analyze
```

## 📄 License

This is a demonstration project for healthcare application development with accessibility features.

## 🆘 Troubleshooting

### Common Issues

**Issue**: "Waiting for another flutter command to release the startup lock"
```bash
killall -9 dart
rm -rf ~/flutter/bin/cache/lockfile
```

**Issue**: Android licenses not accepted
```bash
flutter doctor --android-licenses
```

**Issue**: CocoaPods not installed (iOS)
```bash
sudo gem install cocoapods
pod setup
```

**Issue**: Gradle build failed (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Go Router](https://pub.dev/packages/go_router)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## 🎯 Test Coverage Summary

| Category | Tests | Coverage |
|----------|-------|----------|
| Widget Tests | 8 | Login, Onboarding, Navigation |
| Provider Tests | 15+ | State management, Persistence |
| Model Tests | 12+ | Data structures, Validation |
| Integration Tests | 6+ | Complete user flows |
| Accessibility Tests | 10+ | WCAG compliance |

**Total**: 50+ comprehensive tests covering critical functionality

---
## AI USAGE
AI was used in transcribing most of the FIgma code although several screens were not perfectly transcribed which required additional manual fixing of code and route fixes. 
Application was ran on an android mobile device which passed all google testing prior to installation.
