import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/camera/presentation/screens/camera_screen.dart';
import '../../features/food_detail/presentation/screens/food_detail_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/progress/presentation/screens/weight_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/personal_details_screen.dart';
import '../../features/profile/presentation/screens/privacy_screen.dart';
import '../../features/profile/presentation/screens/notification_settings_screen.dart';
import '../../features/profile/presentation/screens/apple_health_screen.dart';
import '../../features/food/presentation/screens/log_food_screen.dart';
import '../../features/exercise/presentation/screens/log_exercise_screen.dart';
import '../../features/groups/presentation/screens/groups_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_completed') ?? false;
});

final routerProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      final isOnboardingRoute = state.matchedLocation == '/onboarding';
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      // Check if user is authenticated
      final userId = prefs.getString('user_id');
      final accessToken = prefs.getString('access_token');
      final isAuthenticated = userId != null && accessToken != null && userId != 'guest-user';

      // If not onboarding completed, go to onboarding
      if (!onboardingCompleted && !isOnboardingRoute) {
        return '/onboarding';
      }

      // If onboarding completed but on onboarding route, redirect
      if (onboardingCompleted && isOnboardingRoute) {
        return isAuthenticated ? '/home' : '/login';
      }

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && !isAuthRoute && !isOnboardingRoute) {
        return '/login';
      }

      // If authenticated and on auth routes, go to home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main Shell Route with Bottom Navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/progress',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProgressScreen(),
            ),
          ),
          GoRoute(
            path: '/groups',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GroupsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Camera Route (Full Screen)
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),

      // Food Detail Route
      GoRoute(
        path: '/food/:id',
        builder: (context, state) {
          final foodId = state.pathParameters['id'];
          final extra = state.extra as Map<String, dynamic>?;
          return FoodDetailScreen(
            foodId: foodId,
            analysisResult: extra,
          );
        },
      ),

      // Personal Details Route
      GoRoute(
        path: '/personal-details',
        builder: (context, state) => const PersonalDetailsScreen(),
      ),

      // Weight History Route
      GoRoute(
        path: '/weight-history',
        builder: (context, state) => const WeightHistoryScreen(),
      ),

      // Privacy Route
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),

      // Notification Settings Route
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),

      // Log Food Route
      GoRoute(
        path: '/log-food',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final initialTabIndex = extra?['initialTabIndex'] as int? ?? 0;
          return LogFoodScreen(initialTabIndex: initialTabIndex);
        },
      ),

      // Log Exercise Route
      GoRoute(
        path: '/log-exercise',
        builder: (context, state) => const LogExerciseScreen(),
      ),

      // Apple Health Route
      GoRoute(
        path: '/apple-health',
        builder: (context, state) => const AppleHealthScreen(),
      ),

      // Group Detail Route
      GoRoute(
        path: '/groups/:id',
        builder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return GroupDetailScreen(groupId: groupId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
