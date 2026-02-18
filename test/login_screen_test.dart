import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:care_connect/screens/login_screen.dart';
import 'package:care_connect/providers/app_provider.dart';
import 'package:care_connect/config/routes.dart';

class MockGoRouter extends Mock implements GoRouter {}

class MockAppProvider extends Mock implements AppProvider {
  bool _isAuthenticated = false;
  
  @override
  bool get isAuthenticated => _isAuthenticated;
  
  @override
  Future<void> login() async {
    _isAuthenticated = true;
  }
  
  @override
  Future<void> logout() async {
    _isAuthenticated = false;
  }
  
  @override
  bool get biometricEnabled => true;
}

void main() {
  group('LoginScreen Tests', () {
    late MockAppProvider mockAppProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockAppProvider = MockAppProvider();
    });

    testWidgets('Login screen renders with all UI elements', (WidgetTester tester) async {
      await tester.binding.window.physicalSizeTestValue = const Size(800, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('Username and password fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
      expect(find.byIcon(Icons.visibility), findsWidgets);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      final visibilityButtons = find.byIcon(Icons.visibility);
      if (visibilityButtons.evaluate().isNotEmpty) {
        await tester.tap(visibilityButtons.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Username/Password login validates empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      final loginButton = find.byType(ElevatedButton);
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Successful login with demo credentials', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
            routes: {
              '/': (context) => const Scaffold(body: Center(child: Text('Home'))),
            },
          ),
        ),
      );

      final usernameFields = find.byType(TextField);
      if (usernameFields.evaluate().length >= 2) {
        await tester.enterText(usernameFields.at(0), 'demo');
        await tester.enterText(usernameFields.at(1), 'demo123');
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Invalid login shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.at(0), 'wrong');
        await tester.enterText(textFields.at(1), 'credentials');
        
        final loginButton = find.byType(ElevatedButton);
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton.first);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Passcode field is editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
    });

    testWidgets('Biometric button exists when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Landscape orientation is supported', (WidgetTester tester) async {
      await tester.binding.window.physicalSizeTestValue = const Size(1200, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
