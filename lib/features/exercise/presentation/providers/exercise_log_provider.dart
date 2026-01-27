import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_service.dart';

class ExerciseLog {
  final String id;
  final String type;
  final int duration; // minutes
  final int caloriesBurned;
  final String? intensity;
  final String? description;
  final DateTime loggedAt;

  ExerciseLog({
    required this.id,
    required this.type,
    required this.duration,
    required this.caloriesBurned,
    this.intensity,
    this.description,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'duration': duration,
    'caloriesBurned': caloriesBurned,
    'intensity': intensity,
    'description': description,
    'loggedAt': loggedAt.toIso8601String(),
  };

  factory ExerciseLog.fromJson(Map<String, dynamic> json) => ExerciseLog(
    id: json['id'] as String,
    type: json['type'] as String,
    duration: json['duration'] as int,
    caloriesBurned: json['caloriesBurned'] as int,
    intensity: json['intensity'] as String?,
    description: json['description'] as String?,
    loggedAt: DateTime.parse(json['loggedAt'] as String),
  );
}

class ExerciseLogNotifier extends StateNotifier<List<ExerciseLog>> {
  final ApiService _apiService;
  
  ExerciseLogNotifier(this._apiService) : super([]) {
    _loadLogs();
  }

  static const _storageKey = 'exercise_logs';

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      state = jsonList.map((json) => ExerciseLog.fromJson(json)).toList();
    }
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((l) => l.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addLog(ExerciseLog log) async {
    // Save to local state first
    state = [log, ...state];
    await _saveToDisk();
    
    // Also save to server for streak tracking
    try {
      await _apiService.createExerciseEntry(
        type: log.type,
        duration: log.duration,
        caloriesBurned: log.caloriesBurned,
        intensity: log.intensity,
        description: log.description,
        loggedAt: log.loggedAt,
      );
      debugPrint('ExerciseLogNotifier: Saved exercise to server');
    } catch (e) {
      debugPrint('ExerciseLogNotifier: Failed to save exercise to server: $e');
      // Don't throw - local save succeeded
    }
  }

  Future<void> removeLog(String id) async {
    state = state.where((l) => l.id != id).toList();
    await _saveToDisk();
  }

  List<ExerciseLog> getLogsForDate(DateTime date) {
    return state.where((log) =>
      log.loggedAt.year == date.year &&
      log.loggedAt.month == date.month &&
      log.loggedAt.day == date.day
    ).toList();
  }

  int getTotalCaloriesBurnedForDate(DateTime date) {
    return getLogsForDate(date).fold(0, (sum, log) => sum + log.caloriesBurned);
  }
}

final exerciseLogProvider = StateNotifierProvider<ExerciseLogNotifier, List<ExerciseLog>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ExerciseLogNotifier(apiService);
});

// Provider to get today's exercise logs
final todayExerciseLogsProvider = Provider<List<ExerciseLog>>((ref) {
  final logs = ref.watch(exerciseLogProvider);
  final now = DateTime.now();
  return logs.where((log) =>
    log.loggedAt.year == now.year &&
    log.loggedAt.month == now.month &&
    log.loggedAt.day == now.day
  ).toList();
});

// Provider to get today's total burned calories
final todayBurnedCaloriesProvider = Provider<int>((ref) {
  final todayLogs = ref.watch(todayExerciseLogsProvider);
  return todayLogs.fold(0, (sum, log) => sum + log.caloriesBurned);
});
