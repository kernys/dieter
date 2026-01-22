import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

final healthAuthorizationProvider = FutureProvider<bool>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  return healthService.checkAuthorization();
});

class HealthService {
  // Global Health instance
  final Health _health = Health();
  bool _isAuthorized = false;
  bool _isConfigured = false;

  bool get isAuthorized => _isAuthorized;

  // Data types to read from Health
  static final List<HealthDataType> _readTypes = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.DIETARY_PROTEIN_CONSUMED,
    HealthDataType.DIETARY_CARBS_CONSUMED,
    HealthDataType.DIETARY_FATS_CONSUMED,
  ];

  // Data types to write to Health
  static const List<HealthDataType> _writeTypes = [
    HealthDataType.WEIGHT,
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.DIETARY_PROTEIN_CONSUMED,
    HealthDataType.DIETARY_CARBS_CONSUMED,
    HealthDataType.DIETARY_FATS_CONSUMED,
  ];

  /// Check if Health is available on this platform
  bool get isHealthAvailable => Platform.isIOS || Platform.isAndroid;

  /// Configure the health plugin (must be called before use)
  Future<void> _configure() async {
    if (_isConfigured) return;
    await _health.configure();
    _isConfigured = true;
  }

  /// Request authorization to access health data
  Future<bool> requestAuthorization() async {
    if (!isHealthAvailable) return false;

    try {
      // Configure the health plugin before use
      await _configure();

      // Request read permissions
      final readAuthorized = await _health.requestAuthorization(
        _readTypes,
        permissions: _readTypes.map((_) => HealthDataAccess.READ).toList(),
      );

      if (readAuthorized) {
        // Also request write permissions
        final writeAuthorized = await _health.requestAuthorization(
          _writeTypes,
          permissions: _writeTypes.map((_) => HealthDataAccess.WRITE).toList(),
        );
        _isAuthorized = writeAuthorized;
      } else {
        _isAuthorized = false;
      }

      return _isAuthorized;
    } catch (e) {
      debugPrint('Health authorization error: $e');
      return false;
    }
  }

  /// Check if we have authorization
  Future<bool> checkAuthorization() async {
    if (!isHealthAvailable) return false;

    try {
      await _configure();
      final hasPermissions = await _health.hasPermissions(
        _readTypes,
        permissions: _readTypes.map((_) => HealthDataAccess.READ).toList(),
      );
      _isAuthorized = hasPermissions ?? false;
      return _isAuthorized;
    } catch (e) {
      debugPrint('Health check authorization error: $e');
      return false;
    }
  }

  // ========== READ METHODS ==========

  /// Get today's step count
  Future<int> getTodaySteps() async {
    if (!_isAuthorized) return 0;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      debugPrint('Error getting steps: $e');
      return 0;
    }
  }

  /// Get steps for a date range
  Future<List<HealthDataPoint>> getSteps(DateTime start, DateTime end) async {
    if (!_isAuthorized) return [];

    try {
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: start,
        endTime: end,
      );
      return _health.removeDuplicates(data);
    } catch (e) {
      debugPrint('Error getting steps data: $e');
      return [];
    }
  }

  /// Get the latest weight
  Future<double?> getLatestWeight() async {
    if (!_isAuthorized) return null;

    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: thirtyDaysAgo,
        endTime: now,
      );

      if (data.isEmpty) return null;

      // Get the most recent weight
      data.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      final latestWeight = data.first.value;

      if (latestWeight is NumericHealthValue) {
        // Weight is in kg, convert to lbs for the app
        return latestWeight.numericValue.toDouble() * 2.20462;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting weight: $e');
      return null;
    }
  }

  /// Get weight history
  Future<List<WeightEntry>> getWeightHistory(DateTime start, DateTime end) async {
    if (!_isAuthorized) return [];

    try {
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: start,
        endTime: end,
      );

      final uniqueData = _health.removeDuplicates(data);

      return uniqueData.map((point) {
        final value = point.value;
        double weightKg = 0;
        if (value is NumericHealthValue) {
          weightKg = value.numericValue.toDouble();
        }
        return WeightEntry(
          date: point.dateTo,
          weightLbs: weightKg * 2.20462, // Convert kg to lbs
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting weight history: $e');
      return [];
    }
  }

  /// Get today's active calories burned
  Future<double> getTodayActiveCaloriesBurned() async {
    if (!_isAuthorized) return 0;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: now,
      );

      double total = 0;
      for (final point in data) {
        if (point.value is NumericHealthValue) {
          total += (point.value as NumericHealthValue).numericValue.toDouble();
        }
      }
      return total;
    } catch (e) {
      debugPrint('Error getting active calories: $e');
      return 0;
    }
  }

  // ========== WRITE METHODS ==========

  /// Write weight to Health
  Future<bool> writeWeight(double weightLbs) async {
    if (!_isAuthorized) return false;

    try {
      final now = DateTime.now();
      final weightKg = weightLbs * 0.453592; // Convert lbs to kg

      final success = await _health.writeHealthData(
        value: weightKg,
        type: HealthDataType.WEIGHT,
        startTime: now,
        endTime: now,
        unit: HealthDataUnit.KILOGRAM,
      );

      return success;
    } catch (e) {
      debugPrint('Error writing weight: $e');
      return false;
    }
  }

  /// Write nutrition data to Health
  Future<bool> writeNutrition({
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    DateTime? dateTime,
  }) async {
    if (!_isAuthorized) return false;

    try {
      final now = dateTime ?? DateTime.now();
      bool allSuccess = true;

      // Write calories
      allSuccess &= await _health.writeHealthData(
        value: calories.toDouble(),
        type: HealthDataType.DIETARY_ENERGY_CONSUMED,
        startTime: now,
        endTime: now,
        unit: HealthDataUnit.KILOCALORIE,
      );

      // Write protein
      allSuccess &= await _health.writeHealthData(
        value: protein,
        type: HealthDataType.DIETARY_PROTEIN_CONSUMED,
        startTime: now,
        endTime: now,
        unit: HealthDataUnit.GRAM,
      );

      // Write carbs
      allSuccess &= await _health.writeHealthData(
        value: carbs,
        type: HealthDataType.DIETARY_CARBS_CONSUMED,
        startTime: now,
        endTime: now,
        unit: HealthDataUnit.GRAM,
      );

      // Write fat
      allSuccess &= await _health.writeHealthData(
        value: fat,
        type: HealthDataType.DIETARY_FATS_CONSUMED,
        startTime: now,
        endTime: now,
        unit: HealthDataUnit.GRAM,
      );

      return allSuccess;
    } catch (e) {
      debugPrint('Error writing nutrition: $e');
      return false;
    }
  }

  /// Get today's nutrition data from Health
  Future<NutritionSummary> getTodayNutrition() async {
    if (!_isAuthorized) {
      return const NutritionSummary(
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
      );
    }

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final types = [
        HealthDataType.DIETARY_ENERGY_CONSUMED,
        HealthDataType.DIETARY_PROTEIN_CONSUMED,
        HealthDataType.DIETARY_CARBS_CONSUMED,
        HealthDataType.DIETARY_FATS_CONSUMED,
      ];

      final data = await _health.getHealthDataFromTypes(
        types: types,
        startTime: midnight,
        endTime: now,
      );

      double calories = 0;
      double protein = 0;
      double carbs = 0;
      double fat = 0;

      for (final point in data) {
        final value = point.value;
        if (value is NumericHealthValue) {
          switch (point.type) {
            case HealthDataType.DIETARY_ENERGY_CONSUMED:
              calories += value.numericValue.toDouble();
              break;
            case HealthDataType.DIETARY_PROTEIN_CONSUMED:
              protein += value.numericValue.toDouble();
              break;
            case HealthDataType.DIETARY_CARBS_CONSUMED:
              carbs += value.numericValue.toDouble();
              break;
            case HealthDataType.DIETARY_FATS_CONSUMED:
              fat += value.numericValue.toDouble();
              break;
            default:
              break;
          }
        }
      }

      return NutritionSummary(
        calories: calories.round(),
        protein: protein,
        carbs: carbs,
        fat: fat,
      );
    } catch (e) {
      debugPrint('Error getting nutrition: $e');
      return const NutritionSummary(
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
      );
    }
  }
}

/// Weight entry from Health
class WeightEntry {
  final DateTime date;
  final double weightLbs;

  WeightEntry({
    required this.date,
    required this.weightLbs,
  });
}

/// Nutrition summary from Health
class NutritionSummary {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionSummary({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
