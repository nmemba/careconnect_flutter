import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_provider.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/today_view_screen.dart';
import '../screens/medications_screen.dart';
import '../screens/medication_detail_screen.dart';
import '../screens/add_medication_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/communications_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/refill_request_screen.dart';

class AppRouter {
  static GoRouter router(AppProvider appProvider) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (BuildContext context, GoRouterState state) {
        final isAuthenticated = appProvider.isAuthenticated;
        final needsOnboarding = appProvider.needsOnboarding;
        final isOnboarding = state.matchedLocation == '/onboarding';
        final isLogin = state.matchedLocation == '/login';

        // 1) Onboarding gate: if onboarding is required, stay on /onboarding.
        // Allow reaching it from anywhere (including when authenticated).
        if (needsOnboarding) {
          return isOnboarding ? null : '/onboarding';
        }

        // ... existing code ...

        // 2) Auth gate: if not authenticated, stay on /login.
        // (Onboarding is handled above, so we don't need to allow it here.)
        if (!isAuthenticated) {
          return isLogin ? null : '/login';
        }

        // ... existing code ...

        // 3) Authenticated + onboarding complete: keep away from /login and /onboarding.
        if (isLogin || isOnboarding) {
          return '/';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return HomeScreen(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const TodayViewScreen(),
            ),
            GoRoute(
              path: '/medications',
              builder: (context, state) => const MedicationsScreen(),
            ),
            GoRoute(
              path: '/medications/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return MedicationDetailScreen(medicationId: id);
              },
            ),
            GoRoute(
              path: '/medications/add',
              builder: (context, state) => const AddMedicationScreen(),
            ),
            GoRoute(
              path: '/medications/:id/refill',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return RefillRequestScreen(medicationId: id);
              },
            ),
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarScreen(),
            ),
            GoRoute(
              path: '/communications',
              builder: (context, state) => const CommunicationsScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
