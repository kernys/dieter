import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_service.dart';
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

  AuthNotifier(this._apiService) : super(AuthState.initial()) {
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
          state = AuthState.authenticated(
            userId: userId,
            accessToken: accessToken,
            user: user,
          );
        } catch (e) {
          // Token might be invalid, clear stored credentials
          await _clearStoredCredentials();
          state = AuthState.initial();
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
    await _clearStoredCredentials();
    state = AuthState.initial();
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    if (state.userId == null) return;

    try {
      final updatedUser = await _apiService.updateUser(state.userId!, updates);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      rethrow;
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
  return AuthNotifier(apiService);
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
