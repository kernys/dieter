import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class RoleModelNotifier extends StateNotifier<String?> {
  final Ref _ref;
  String? _lastUserId;

  RoleModelNotifier(this._ref) : super(null) {
    // Listen for auth state changes
    _ref.listen(authStateProvider, (previous, next) {
      if (next.userId != null && next.userId != _lastUserId) {
        _lastUserId = next.userId;
        _loadImage();
      } else if (next.userId == null && _lastUserId != null) {
        // User logged out
        _lastUserId = null;
        state = null;
      }
    });
    
    // Initial load
    _loadImage();
  }

  static const _localCacheKey = 'role_model_image_cache';

  Future<void> _loadImage() async {
    // First try to load from server via user profile
    final authState = _ref.read(authStateProvider);
    debugPrint('RoleModel: Loading image, userId: ${authState.userId}');
    
    if (authState.userId != null) {
      try {
        final apiService = _ref.read(apiServiceProvider);
        final user = await apiService.getUser(authState.userId!);
        debugPrint('RoleModel: Got user, roleModelImageUrl: ${user.roleModelImageUrl}');
        
        if (user.roleModelImageUrl != null && user.roleModelImageUrl!.isNotEmpty) {
          state = user.roleModelImageUrl;
          // Cache the URL locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_localCacheKey, user.roleModelImageUrl!);
          debugPrint('RoleModel: Set state to URL from server');
          return;
        }
      } catch (e) {
        debugPrint('RoleModel: Error loading from server: $e');
        // Fall back to local cache on error
      }
    }

    // Fall back to local cache
    final prefs = await SharedPreferences.getInstance();
    final cachedUrl = prefs.getString(_localCacheKey);
    debugPrint('RoleModel: Fallback to local cache: $cachedUrl');
    state = cachedUrl;
  }

  Future<void> setImage(String localPath) async {
    final authState = _ref.read(authStateProvider);
    if (authState.userId == null) {
      // Not logged in, just save locally
      state = localPath;
      return;
    }

    try {
      // Read file and upload to server
      final file = File(localPath);
      final Uint8List imageBytes = await file.readAsBytes();

      final apiService = _ref.read(apiServiceProvider);
      final uploadedUrl = await apiService.uploadImage(imageBytes);

      // Save URL to user profile
      await apiService.updateUser(authState.userId!, {
        'roleModelImageUrl': uploadedUrl,
      });

      // Update local cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localCacheKey, uploadedUrl);

      state = uploadedUrl;
    } catch (e) {
      // On upload failure, save locally as fallback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localCacheKey, localPath);
      state = localPath;
      rethrow;
    }
  }

  Future<void> removeImage() async {
    final authState = _ref.read(authStateProvider);

    if (authState.userId != null) {
      try {
        final apiService = _ref.read(apiServiceProvider);
        await apiService.updateUser(authState.userId!, {
          'roleModelImageUrl': null,
        });
      } catch (e) {
        // Continue with local removal even if server fails
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localCacheKey);
    state = null;
  }

  /// Refresh from server (call after login)
  Future<void> refreshFromServer() async {
    await _loadImage();
  }
}

final roleModelProvider = StateNotifierProvider<RoleModelNotifier, String?>((ref) {
  return RoleModelNotifier(ref);
});
