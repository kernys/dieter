import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/router/app_router.dart';
import 'api_service.dart';

/// Global error handler service for showing user-friendly error messages
class ErrorHandlerService {
  /// Shows an error dialog to the user
  static void showErrorDialog({
    required String title,
    required String message,
    VoidCallback? onDismiss,
  }) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  /// Shows a snackbar with an error message
  static void showErrorSnackBar(String message) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  /// Handles API exceptions and shows appropriate error messages
  static void handleApiError(ApiException error, {String? customMessage}) {
    String title;
    String message;
    
    if (error.isNetworkError) {
      title = 'Connection Error';
      message = 'Please check your internet connection and try again.';
    } else if (error.statusCode >= 500) {
      title = 'Server Error';
      message = customMessage ?? 'The server is temporarily unavailable. Please try again later.';
    } else if (error.statusCode == 401) {
      title = 'Session Expired';
      message = 'Your session has expired. Please sign in again.';
    } else if (error.statusCode == 403) {
      title = 'Access Denied';
      message = 'You do not have permission to perform this action.';
    } else if (error.statusCode == 404) {
      title = 'Not Found';
      message = customMessage ?? 'The requested resource was not found.';
    } else {
      title = 'Error';
      message = customMessage ?? error.message;
    }
    
    showErrorDialog(title: title, message: message);
  }
}

final errorHandlerProvider = Provider<ErrorHandlerService>((ref) {
  return ErrorHandlerService();
});
