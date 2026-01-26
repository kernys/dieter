import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/notification_service.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Catch Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        // Log to crash reporting service in production
        debugPrint('Flutter error: ${details.exception}');
      }
    };

    // Initialize notification service
    await NotificationService().initialize();

    // Set system UI style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(
      const ProviderScope(
        child: CalAIApp(),
      ),
    );
  }, (error, stackTrace) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}
