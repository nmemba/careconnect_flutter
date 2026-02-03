# CareConnect Testing Guide

Comprehensive guide for testing the CareConnect Flutter application.

## 📋 Table of Contents

1. [Test Structure](#test-structure)
2. [Running Tests](#running-tests)
3. [Test Categories](#test-categories)
4. [Writing New Tests](#writing-new-tests)
5. [Test Coverage](#test-coverage)
6. [CI/CD Integration](#cicd-integration)

## 🗂️ Test Structure

```
flutter/test/
├── widget_test.dart           # UI component tests
├── provider_test.dart         # State management tests
├── model_test.dart            # Data model tests
├── integration_test.dart      # End-to-end user flow tests
└── accessibility_test.dart    # WCAG compliance tests
```

## 🏃 Running Tests

### All Tests
```bash
flutter test
```

### Specific Test File
```bash
flutter test test/widget_test.dart
```

### Specific Test Group
```bash
flutter test --plain-name "AppProvider Tests"
```

### With Coverage
```bash
flutter test --coverage
```

### Verbose Output
```bash
flutter test --reporter expanded
```

### Watch Mode (re-run on changes)
```bash
flutter test --watch
```

## 📊 Test Categories

### 1. Widget Tests (`widget_test.dart`)

**Purpose**: Test UI components and user interactions

**Examples**:
- App loads correctly
- Login screen shows all elements
- Touch targets meet minimum size
- Forms are editable
- Navigation works

**Run**:
```bash
flutter test test/widget_test.dart
```

**Sample Test**:
```dart
testWidgets('Login screen has all required elements', (WidgetTester tester) async {
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  
  expect(find.text('Sign In'), findsWidgets);
  expect(find.byType(TextField), findsNWidgets(2));
});
```

### 2. Provider Tests (`provider_test.dart`)

**Purpose**: Test state management and data persistence

**Examples**:
- Authentication state changes
- Settings persist to storage
- Medication CRUD operations
- Favorite management
- Onboarding flow

**Run**:
```bash
flutter test test/provider_test.dart
```

**Sample Test**:
```dart
test('Left-hand mode persists to storage', () async {
  await appProvider.setLeftHandMode(true);
  
  expect(appProvider.leftHandMode, true);
  expect(prefs.getBool('leftHandMode'), true);
});
```

### 3. Model Tests (`model_test.dart`)

**Purpose**: Test data structures and business logic

**Examples**:
- Model creation
- `copyWith` functionality
- Data validation
- Default values
- Required fields

**Run**:
```bash
flutter test test/model_test.dart
```

**Sample Test**:
```dart
test('Medication can be created', () {
  final medication = Medication(
    id: '1',
    name: 'Test Med',
    // ... other fields
  );
  
  expect(medication.name, 'Test Med');
  expect(medication.refillsRemaining, 3);
});
```

### 4. Integration Tests (`integration_test.dart`)

**Purpose**: Test complete user workflows end-to-end

**Examples**:
- Complete onboarding → login → dashboard flow
- Add medication workflow
- Refill request 3-step process
- Navigation between all screens
- Settings changes persist across navigation

**Run**:
```bash
flutter test test/integration_test.dart
```

**Sample Test**:
```dart
testWidgets('Complete onboarding and login flow', (WidgetTester tester) async {
  await tester.pumpWidget(app);
  
  // Step 1: Onboarding
  await tester.tap(find.text('Left Hand'));
  await tester.tap(find.text('Continue'));
  
  // Step 2: Login
  await tester.enterText(usernameField, 'demo');
  await tester.tap(find.text('Sign In'));
  
  // Verify: Reached dashboard
  expect(find.text('Today'), findsOneWidget);
});
```

### 5. Accessibility Tests (`accessibility_test.dart`)

**Purpose**: Verify WCAG 2.1 Level AA compliance

**Examples**:
- Touch targets ≥ 48dp (landscape) / 56dp (portrait)
- Color contrast ratios meet WCAG standards
- Semantic labels present
- Left-hand mode works correctly
- Keyboard navigation

**Run**:
```bash
flutter test test/accessibility_test.dart
```

**Sample Test**:
```dart
testWidgets('Touch targets meet minimum size requirements', (tester) async {
  await tester.pumpWidget(app);
  
  final buttons = find.byType(ElevatedButton);
  for (final button in buttons.evaluate()) {
    final size = (button.renderObject as RenderBox).size;
    expect(size.height, greaterThanOrEqualTo(48.0));
  }
});
```

## ✍️ Writing New Tests

### Basic Widget Test Template

```dart
testWidgets('Description of test', (WidgetTester tester) async {
  // 1. Setup
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  
  // 2. Build widget
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AppProvider(prefs),
      child: const CareConnectApp(),
    ),
  );
  await tester.pumpAndSettle();
  
  // 3. Interact
  await tester.tap(find.text('Button'));
  await tester.pump();
  
  // 4. Verify
  expect(find.text('Expected Result'), findsOneWidget);
});
```

### Basic Unit Test Template

```dart
test('Description of test', () async {
  // 1. Setup
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final appProvider = AppProvider(prefs);
  
  // 2. Execute
  await appProvider.someMethod();
  
  // 3. Verify
  expect(appProvider.someValue, expectedValue);
});
```

### Common Assertions

```dart
// Finding widgets
expect(find.text('Text'), findsOneWidget);
expect(find.byType(Button), findsNWidgets(2));
expect(find.byIcon(Icons.add), findsWidgets);
expect(find.text('Not Found'), findsNothing);

// Values
expect(value, equals(expectedValue));
expect(value, isTrue);
expect(value, isFalse);
expect(value, isNull);
expect(value, isNotNull);

// Comparisons
expect(value, greaterThan(5));
expect(value, lessThan(10));
expect(value, greaterThanOrEqualTo(5));

// Collections
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, contains(item));
expect(list.length, equals(3));
```

### Common Interactions

```dart
// Tapping
await tester.tap(find.text('Button'));
await tester.tap(find.byIcon(Icons.add));

// Entering text
await tester.enterText(find.byType(TextField).first, 'Hello');

// Scrolling
await tester.drag(find.byType(ListView), const Offset(0, -200));

// Long press
await tester.longPress(find.text('Item'));

// Waiting for animations
await tester.pump(); // Single frame
await tester.pumpAndSettle(); // All frames until settled
await tester.pump(const Duration(seconds: 1)); // Specific duration
```

## 📈 Test Coverage

### Generate Coverage Report

```bash
# 1. Run tests with coverage
flutter test --coverage

# 2. Install lcov (if not installed)
# macOS:
brew install lcov

# Linux:
sudo apt-get install lcov

# 3. Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# 4. Open report
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

### Coverage Goals

| Component | Target Coverage |
|-----------|----------------|
| Models | 100% |
| Providers | 90%+ |
| Screens | 80%+ |
| Widgets | 80%+ |
| **Overall** | **85%+** |

### View Coverage in VS Code

1. Install "Coverage Gutters" extension
2. Run tests with coverage
3. Press `Cmd+Shift+P` → "Coverage Gutters: Display Coverage"
4. Green = covered, Red = not covered

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
name: Flutter Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: coverage/lcov.info
```

### GitLab CI Example

```yaml
test:
  image: cirrusci/flutter:latest
  stage: test
  script:
    - flutter pub get
    - flutter test --coverage
  coverage: '/lines......: \d+\.\d+%/'
  artifacts:
    paths:
      - coverage/
```

## 🐛 Debugging Tests

### Print Debug Information

```dart
testWidgets('Debug test', (tester) async {
  await tester.pumpWidget(app);
  
  // Print widget tree
  debugDumpApp();
  
  // Print render tree
  debugDumpRenderTree();
  
  // Print all text widgets
  print(find.text('', findRichText: true).evaluate());
});
```

### Test Specific Widget

```dart
testWidgets('Test specific widget', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: YourWidget(),
      ),
    ),
  );
  
  // Test just this widget
});
```

### Mock Data

```dart
class MockAppProvider extends AppProvider {
  MockAppProvider(super.prefs);
  
  @override
  List<Medication> get medications => [
    Medication(/* test data */),
  ];
}
```

## 📝 Best Practices

### ✅ DO

- Test user-facing behavior, not implementation
- Use descriptive test names
- Keep tests independent and isolated
- Clean up resources in `setUp()` and `tearDown()`
- Test edge cases and error states
- Use `pumpAndSettle()` for animations
- Mock external dependencies
- Test accessibility features

### ❌ DON'T

- Test private methods directly
- Make tests dependent on other tests
- Use hard-coded delays (`await Future.delayed()`)
- Test implementation details
- Skip `pumpAndSettle()` after interactions
- Ignore failing tests
- Write overly complex test setup

## 🎯 Testing Checklist

### Before Every Commit

- [ ] All tests pass: `flutter test`
- [ ] No test warnings or errors
- [ ] Coverage hasn't decreased
- [ ] New features have tests
- [ ] Accessibility tests pass

### For New Features

- [ ] Widget tests for UI
- [ ] Unit tests for business logic
- [ ] Integration test for user flow
- [ ] Accessibility compliance verified
- [ ] Edge cases covered

### For Bug Fixes

- [ ] Add test that reproduces bug
- [ ] Verify test fails before fix
- [ ] Verify test passes after fix
- [ ] Check no regressions

## 🔍 Example Test Scenarios

### Testing Authentication Flow

```dart
group('Authentication Flow', () {
  testWidgets('User can login with valid credentials', (tester) async {
    // ... setup
    
    await tester.enterText(usernameField, 'demo');
    await tester.enterText(passwordField, 'demo123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    
    expect(find.text('Today'), findsOneWidget);
  });
  
  testWidgets('Error shown for invalid credentials', (tester) async {
    // ... setup
    
    await tester.enterText(usernameField, 'wrong');
    await tester.enterText(passwordField, 'wrong');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    
    expect(find.text('Invalid username or password'), findsOneWidget);
  });
});
```

### Testing State Persistence

```dart
test('Settings persist across app restarts', () async {
  final prefs = await SharedPreferences.getInstance();
  
  // First session
  final provider1 = AppProvider(prefs);
  await provider1.setLeftHandMode(true);
  
  // Second session (simulating app restart)
  final provider2 = AppProvider(prefs);
  
  expect(provider2.leftHandMode, true);
});
```

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Testing Best Practices](https://docs.flutter.dev/testing/best-practices)

---

Happy Testing! 🧪✨
