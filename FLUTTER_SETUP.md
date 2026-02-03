# Flutter Setup Guide

Complete guide for setting up and running the CareConnect Flutter application.

## Prerequisites

### 1. Install Flutter SDK

#### macOS
```bash
# Download Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor
```

#### Windows
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to desired location (e.g., `C:\src\flutter`)
3. Add to PATH: `C:\src\flutter\bin`
4. Run `flutter doctor` in Command Prompt

#### Linux
```bash
# Download Flutter SDK
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz

# Add to PATH (add to ~/.bashrc)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor
```

### 2. Install Platform Tools

#### For iOS Development (macOS only)
```bash
# Install Xcode from App Store
# Install CocoaPods
sudo gem install cocoapods

# Accept Xcode license
sudo xcodebuild -license accept
```

#### For Android Development
1. Download and install Android Studio from https://developer.android.com/studio
2. Open Android Studio
3. Go to Preferences → Appearance & Behavior → System Settings → Android SDK
4. Install SDK Platform for Android API 33 or higher
5. Install SDK Tools: Android SDK Build-Tools, Android SDK Command-line Tools
6. Set ANDROID_HOME environment variable:

**macOS/Linux:**
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

**Windows:**
```
ANDROID_HOME=C:\Users\YourUsername\AppData\Local\Android\Sdk
```

### 3. Verify Setup
```bash
flutter doctor -v
```

Fix any issues reported by `flutter doctor`.

## Running the App

### 1. Install Dependencies
```bash
cd flutter
flutter pub get
```

### 2. Run on Emulator/Simulator

#### iOS Simulator (macOS only)
```bash
# List available simulators
flutter emulators

# Launch simulator
flutter emulators --launch apple_ios_simulator

# Run app
flutter run
```

#### Android Emulator
```bash
# Create emulator in Android Studio or via command line
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch Pixel_5_API_33

# Run app
flutter run
```

### 3. Run on Physical Device

#### iOS Device
1. Connect iPhone via USB
2. Trust computer on device
3. Open Xcode, select device, and ensure provisioning profile is set up
4. Run: `flutter run`

#### Android Device
1. Enable Developer Mode on device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Go to Settings → Developer Options
   - Enable "USB Debugging"
3. Connect device via USB
4. Accept USB debugging prompt on device
5. Run: `flutter run`

### 4. Hot Reload During Development
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

## Project Configuration

### Dependencies Overview

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1           # State management solution
  
  # Local Storage
  shared_preferences: ^2.2.2 # Persist user settings
  
  # Navigation
  go_router: ^13.0.0         # Declarative routing
  
  # Utilities
  intl: ^0.19.0              # Date/time formatting
  
  # UI Components
  flutter_slidable: ^3.0.1   # Swipe actions (optional)
```

### Minimum Requirements
- **SDK**: Dart >=3.0.0 <4.0.0
- **Flutter**: >=3.0.0
- **iOS**: 12.0+
- **Android**: API Level 21 (Android 5.0) or higher

## Common Issues & Solutions

### Issue: "Doctor found issues in 1 category"
**Solution**: Run `flutter doctor` and follow the specific recommendations for your platform.

### Issue: "Waiting for another flutter command to release the startup lock"
**Solution**:
```bash
killall -9 dart
rm -rf ~/flutter/bin/cache/lockfile
```

### Issue: "Could not find an option named 'no-sound-null-safety'"
**Solution**: You're using an older Flutter version. Update with:
```bash
flutter upgrade
```

### Issue: Android licenses not accepted
**Solution**:
```bash
flutter doctor --android-licenses
```
Accept all licenses when prompted.

### Issue: CocoaPods not installed (iOS)
**Solution**:
```bash
sudo gem install cocoapods
pod setup
```

### Issue: "Building for iOS, but the linked and embedded framework was built for iOS Simulator"
**Solution**: This is an architecture mismatch. Clean and rebuild:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

## IDE Setup

### Visual Studio Code
1. Install Flutter extension
2. Install Dart extension
3. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
4. Type "Flutter: New Project" to verify setup

Recommended VS Code extensions:
- Flutter
- Dart
- Pubspec Assist
- Flutter Widget Snippets

### Android Studio
1. Install Flutter plugin: Preferences → Plugins → Search "Flutter"
2. Install Dart plugin (usually installed with Flutter plugin)
3. Restart Android Studio
4. Create new Flutter project or open existing one

## Performance Tips

### Development
- Use `flutter run --profile` for performance testing
- Use Flutter DevTools: `flutter pub global activate devtools`

### Production
- Build release version:
  ```bash
  flutter build apk --release  # Android
  flutter build ios --release  # iOS
  ```
- Enable obfuscation:
  ```bash
  flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols
  ```

## Debugging

### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Then run your app and click the link shown in the terminal.

### Debug Prints
```dart
import 'dart:developer' as developer;

developer.log('Debug message', name: 'CareConnect');
```

### Logging
The app uses standard Flutter logging. View logs with:
```bash
flutter logs
```

## Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test
```bash
flutter test test/specific_test.dart
```

### Widget Testing
```bash
flutter test --platform=chrome  # Run in browser
```

## Deployment

### Android (Google Play)
1. Update version in `pubspec.yaml`
2. Build release APK or App Bundle:
   ```bash
   flutter build appbundle --release
   ```
3. Sign with your keystore
4. Upload to Google Play Console

### iOS (App Store)
1. Update version in `pubspec.yaml`
2. Build release:
   ```bash
   flutter build ios --release
   ```
3. Open `ios/Runner.xcworkspace` in Xcode
4. Archive and upload to App Store Connect

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Flutter Samples](https://flutter.dev/docs/cookbook)

## Support

For Flutter-specific issues:
- Flutter GitHub: https://github.com/flutter/flutter/issues
- Stack Overflow: Tag with `flutter`
- Flutter Community: https://flutter.dev/community
