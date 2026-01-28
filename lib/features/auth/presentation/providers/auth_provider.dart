import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_service.dart';
import '../../../../services/cache_service.dart';
import '../../../../services/error_handler_service.dart';
import '../../../../services/notification_service.dart';
import '../../../../shared/models/user_model.dart';

// Auth state class
class AuthState {
  final String? userId;
  final String? accessToken;
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;

  const AuthState({
    this.userId,
    this.accessToken,
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
  });

  // Check if user is in guest mode (no real account)
  bool get isGuestMode => userId == 'guest-user';

  AuthState copyWith({
    String? userId,
    String? accessToken,
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory AuthState.initial() => const AuthState();

  factory AuthState.authenticated({
    required String userId,
    required String accessToken,
    UserModel? user,
  }) =>
      AuthState(
        userId: userId,
        accessToken: accessToken,
        user: user,
        isAuthenticated: true,
      );
}

// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final CacheService _cacheService;
  final NotificationService _notificationService;

  AuthNotifier(this._apiService, this._cacheService, this._notificationService) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final accessToken = prefs.getString('access_token');

      if (userId != null && accessToken != null) {
        _apiService.setAuthToken(accessToken);

        try {
          final user = await _apiService.getUser(userId);
          debugPrint('AuthNotifier._checkAuthStatus - loaded user goalWeight: ${user.goalWeight}');
          // Cache user data for offline use
          await _cacheService.cacheUser(userId, user);
          // Schedule notifications based on user settings
          await _notificationService.scheduleAllReminders(user);
          state = AuthState.authenticated(
            userId: userId,
            accessToken: accessToken,
            user: user,
          );
        } catch (e) {
          // Check if it's a network error or server error
          if (e is ApiException) {
            if (e.isNetworkError) {
              // Network error - try to load from cache
              debugPrint('AuthNotifier._checkAuthStatus - network error, loading from cache');
              final cachedUser = await _cacheService.getCachedUser(userId);
              state = AuthState.authenticated(
                userId: userId,
                accessToken: accessToken,
                user: cachedUser, // Use cached data, null if not available
              );
              // Show alert for network error
              ErrorHandlerService.showErrorDialog(
                title: 'Connection Error',
                message: 'Unable to connect to the server. Using cached data.',
              );
            } else if (e.statusCode >= 500) {
              // Server error - try to load from cache and show alert
              debugPrint('AuthNotifier._checkAuthStatus - server error (${e.statusCode}), loading from cache');
              final cachedUser = await _cacheService.getCachedUser(userId);
              state = AuthState.authenticated(
                userId: userId,
                accessToken: accessToken,
                user: cachedUser,
              );
              // Show alert for server error
              ErrorHandlerService.showErrorDialog(
                title: 'Server Error',
                message: 'The server is temporarily unavailable. Please try again later.',
              );
            } else if (e.statusCode == 401) {
              // Token is invalid (Unauthorized), clear stored credentials
              debugPrint('AuthNotifier._checkAuthStatus - token invalid (401), logging out');
              await _clearStoredCredentials();
              state = AuthState.initial();
            } else {
              // Other client errors (4xx) - still keep user logged in with cached data
              debugPrint('AuthNotifier._checkAuthStatus - client error (${e.statusCode}), loading from cache');
              final cachedUser = await _cacheService.getCachedUser(userId);
              state = AuthState.authenticated(
                userId: userId,
                accessToken: accessToken,
                user: cachedUser,
              );
            }
          } else {
            // Unknown error - keep user logged in with cached data
            debugPrint('AuthNotifier._checkAuthStatus - unknown error: $e, loading from cache');
            final cachedUser = await _cacheService.getCachedUser(userId);
            state = AuthState.authenticated(
              userId: userId,
              accessToken: accessToken,
              user: cachedUser,
            );
          }
        }
      } else {
        state = AuthState.initial();
      }
    } catch (e) {
      state = AuthState.initial();
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _apiService.login(email, password);

      final userId = response.user['id'] as String;
      final accessToken = response.session?['accessToken'] as String?;

      if (accessToken != null) {
        await _storeCredentials(userId, accessToken);

        final user = await _apiService.getUser(userId);

        // Cache user data for offline use
        await _cacheService.cacheUser(userId, user);
        
        // Schedule notifications based on user settings
        await _notificationService.scheduleAllReminders(user);

        state = AuthState.authenticated(
          userId: userId,
          accessToken: accessToken,
          user: user,
        );
      } else {
        throw Exception('No access token received');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> signup(String email, String password, String? name) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _apiService.signup(email, password, name);

      final userId = response.user['id'] as String;
      final accessToken = response.session?['accessToken'] as String?;

      if (accessToken != null) {
        await _storeCredentials(userId, accessToken);

        final user = await _apiService.getUser(userId);

        // Cache user data for offline use
        await _cacheService.cacheUser(userId, user);
        
        // Schedule notifications based on user settings
        await _notificationService.scheduleAllReminders(user);

        state = AuthState.authenticated(
          userId: userId,
          accessToken: accessToken,
          user: user,
        );
      } else {
        // Email confirmation might be required
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    // Clear cache when logging out
    if (state.userId != null) {
      await _cacheService.clearUserCache(state.userId!);
    }
    // Cancel all notifications
    await _notificationService.cancelAllReminders();
    await _clearStoredCredentials();
    state = AuthState.initial();
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    if (state.userId == null) return;

    try {
      final updatedUser = await _apiService.updateUser(state.userId!, updates);
      // Cache updated user data
      await _cacheService.cacheUser(state.userId!, updatedUser);
      
      // Reschedule notifications if reminder settings changed
      final reminderKeys = [
        'breakfastReminderEnabled', 'breakfastReminderTime',
        'lunchReminderEnabled', 'lunchReminderTime',
        'snackReminderEnabled', 'snackReminderTime',
        'dinnerReminderEnabled', 'dinnerReminderTime',
        'endOfDayReminderEnabled', 'endOfDayReminderTime',
      ];
      if (updates.keys.any((key) => reminderKeys.contains(key))) {
        await _notificationService.scheduleAllReminders(updatedUser);
      }
      
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh user data from server
  Future<void> refreshUser() async {
    if (state.userId == null || state.isGuestMode) return;

    try {
      final user = await _apiService.getUser(state.userId!);
      // Cache refreshed user data
      await _cacheService.cacheUser(state.userId!, user);
      state = state.copyWith(user: user);
    } catch (e) {
      debugPrint('Failed to refresh user: $e');
    }
  }

  Future<void> _storeCredentials(String userId, String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    await prefs.setString('access_token', accessToken);
  }

  Future<void> _clearStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('access_token');
  }

  // For demo/skip login mode - create a guest session
  void setGuestMode() {
    state = AuthState(
      userId: 'guest-user',
      isAuthenticated: true,
    );
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final cacheService = ref.watch(cacheServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return AuthNotifier(apiService, cacheService, notificationService);
});

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).user;
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).userId;
});

final isGuestModeProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isGuestMode;
});
