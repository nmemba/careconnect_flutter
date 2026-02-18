import 'package:flutter_test/flutter_test.dart';
import 'package:care_connect/config/routes.dart';
import 'package:care_connect/config/theme.dart';

void main() {
  group('Routes Configuration Tests', () {
    test('Routes are properly configured', () {
      expect(routes, isNotNull);
    });

    test('Home route exists', () {
      final homeRoute = routes.firstWhereOrNull((route) => route.path == '/');
      expect(homeRoute, isNotNull);
    });

    test('Medications route exists', () {
      final medsRoute = routes.firstWhereOrNull((route) => route.path.contains('medications'));
      expect(medsRoute, isNotNull);
    });

    test('Appointments route exists', () {
      final apptRoute = routes.firstWhereOrNull((route) => route.path.contains('appointments'));
      expect(apptRoute, isNotNull);
    });

    test('Settings route exists', () {
      final settingsRoute = routes.firstWhereOrNull((route) => route.path.contains('settings'));
      expect(settingsRoute, isNotNull);
    });

    test('Login route exists', () {
      final loginRoute = routes.firstWhereOrNull((route) => route.path.contains('login'));
      expect(loginRoute, isNotNull);
    });

    test('Onboarding route exists', () {
      final onboardingRoute = routes.firstWhereOrNull((route) => route.path.contains('onboarding'));
      expect(onboardingRoute, isNotNull);
    });

    test('Route structure is valid', () {
      for (var route in routes) {
        expect(route.path, isNotEmpty);
      }
    });

    test('Routes list is not empty', () {
      expect(routes.isNotEmpty, true);
      expect(routes.length, greaterThan(0));
    });
  });

  group('AppTheme Configuration Tests', () {
    test('Primary color is defined', () {
      expect(AppTheme.primaryColor, isNotNull);
    });

    test('Secondary colors are defined', () {
      expect(AppTheme.primaryLight, isNotNull);
      expect(AppTheme.primaryDark, isNotNull);
    });

    test('Neutral colors are defined', () {
      expect(AppTheme.grayLight, isNotNull);
      expect(AppTheme.grayMedium, isNotNull);
      expect(AppTheme.grayDark, isNotNull);
    });

    test('Semantic colors are defined', () {
      expect(AppTheme.successColor, isNotNull);
      expect(AppTheme.warningColor, isNotNull);
      expect(AppTheme.errorColor, isNotNull);
    });

    test('Background color is defined', () {
      expect(AppTheme.grayBg, isNotNull);
    });

    test('Border radius constants are defined', () {
      expect(AppTheme.borderRadiusSmall, greaterThan(0));
      expect(AppTheme.borderRadiusMedium, greaterThan(0));
      expect(AppTheme.borderRadiusLarge, greaterThan(0));
    });

    test('Colors are valid Color instances', () {
      expect(AppTheme.primaryColor.value, isNotNull);
      expect(AppTheme.successColor.value, isNotNull);
      expect(AppTheme.errorColor.value, isNotNull);
    });

    test('Theme brightness is appropriate', () {
      expect(AppTheme.primaryLight.value != AppTheme.primaryDark.value, true);
    });

    test('Spacing constants are consistent', () {
      expect(AppTheme.borderRadiusSmall, lessThan(AppTheme.borderRadiusMedium));
      expect(AppTheme.borderRadiusMedium, lessThan(AppTheme.borderRadiusLarge));
    });

    test('All required theme colors present', () {
      expect(AppTheme.primaryColor, isNotNull);
      expect(AppTheme.primaryLight, isNotNull);
      expect(AppTheme.primaryDark, isNotNull);
      expect(AppTheme.successColor, isNotNull);
      expect(AppTheme.warningColor, isNotNull);
      expect(AppTheme.errorColor, isNotNull);
      expect(AppTheme.infoColor, isNotNull);
      expect(AppTheme.grayLight, isNotNull);
      expect(AppTheme.grayMedium, isNotNull);
      expect(AppTheme.grayDark, isNotNull);
      expect(AppTheme.grayBg, isNotNull);
    });
  });
}

extension FirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
