import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilecalorietrackers/features/auth/login_screen.dart';
import 'package:mobilecalorietrackers/features/dashboard/dashboard_screen.dart';
import 'package:mobilecalorietrackers/features/log_meal/log_meal_screen.dart';
import 'package:mobilecalorietrackers/features/splash/splash_screen.dart';
import 'package:mobilecalorietrackers/features/history/history_screen.dart';
import 'package:mobilecalorietrackers/features/profile/profile_screen.dart';

// Use riverpod provider for the router if state changes might affect routes (e.g., auth)
// final routerProvider = Provider<GoRouter>((ref) { ... });

// Define route names as constants
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String logMeal = '/log-meal';
  static const String history = '/history';
  static const String profile = '/profile'; 
  // Add other route names here
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash, 
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: DashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.logMeal,
        builder: (BuildContext context, GoRouterState state) {
          return const LogMealScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HistoryScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfileScreen(),
        ),
      ),
      // Add other routes (e.g., signup, settings) here
    ],
    // Optional: Add error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
    // Optional: Add redirection logic (e.g., check auth state)
    // redirect: (context, state) {
    //   // Check auth state from a provider
    //   final bool loggedIn = false; // Replace with actual auth check
    //   final bool loggingIn = state.matchedLocation == '/login';

    //   // If not logged in and not on login page, redirect to login
    //   if (!loggedIn && !loggingIn && state.matchedLocation != '/') return '/login';

    //   // If logged in and on login page, redirect to dashboard
    //   if (loggedIn && loggingIn) return '/dashboard';

    //   // No redirect needed
    //   return null;
    // },
  );
}
