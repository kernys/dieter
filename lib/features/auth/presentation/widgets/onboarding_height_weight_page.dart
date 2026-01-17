import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingHeightWeightPage extends ConsumerStatefulWidget {
  const OnboardingHeightWeightPage({super.key});

  @override
  ConsumerState<OnboardingHeightWeightPage> createState() =>
      _OnboardingHeightWeightPageState();
}

class _OnboardingHeightWeightPageState
    extends ConsumerState<OnboardingHeightWeightPage> {
  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late FixedExtentScrollController _weightController;

  bool _isMetric = false;

  // Imperial ranges (5'7" = 170cm)
  int _selectedFeet = 5;
  int _selectedInches = 7;
  int _selectedWeightLbs = 150;

  // Metric ranges
  int _selectedHeightCm = 170;
  int _selectedWeightKg = 68;

  static const int _minFeet = 3;
  static const int _maxFeet = 8;
  static const int _minWeightLbs = 60;
  static const int _maxWeightLbs = 400;
  static const int _minHeightCm = 100;
  static const int _maxHeightCm = 250;
  static const int _minWeightKg = 30;
  static const int _maxWeightKg = 200;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingProvider);

    // Check if metric was previously selected
    _isMetric = onboardingState.unitSystem == UnitSystem.metric;

    // Load saved values or use defaults
    if (_isMetric) {
      // Metric mode
      if (onboardingState.heightCm != null) {
        _selectedHeightCm = onboardingState.heightCm!.toInt();
      }
      if (onboardingState.currentWeightKg != null) {
        _selectedWeightKg = onboardingState.currentWeightKg!.toInt();
      }

      _feetController =
          FixedExtentScrollController(initialItem: _selectedHeightCm - _minHeightCm);
      _inchesController =
          FixedExtentScrollController(initialItem: 0);
      _weightController = FixedExtentScrollController(
          initialItem: _selectedWeightKg - _minWeightKg);
    } else {
      // Imperial mode
      if (onboardingState.heightFeet != null) {
        _selectedFeet = onboardingState.heightFeet!;
      }
      if (onboardingState.heightInches != null) {
        _selectedInches = onboardingState.heightInches!;
      }
      if (onboardingState.currentWeight != null) {
        _selectedWeightLbs = onboardingState.currentWeight!.toInt();
      }

      _feetController =
          FixedExtentScrollController(initialItem: _selectedFeet - _minFeet);
      _inchesController =
          FixedExtentScrollController(initialItem: _selectedInches);
      _weightController = FixedExtentScrollController(
          initialItem: _selectedWeightLbs - _minWeightLbs);
    }

    _updateValues();
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _updateValues() {
    final notifier = ref.read(onboardingProvider.notifier);

    if (_isMetric) {
      notifier.setHeight(cm: _selectedHeightCm.toDouble());
      notifier.setCurrentWeight(kg: _selectedWeightKg.toDouble());
    } else {
      notifier.setHeight(feet: _selectedFeet, inches: _selectedInches);
      notifier.setCurrentWeight(lbs: _selectedWeightLbs.toDouble());
    }
  }

  void _toggleUnit(bool isMetric) {
    if (_isMetric == isMetric) return;

    setState(() {
      if (isMetric) {
        // Convert imperial to metric
        final totalInches = _selectedFeet * 12 + _selectedInches;
        _selectedHeightCm = (totalInches * 2.54).round();
        _selectedWeightKg = (_selectedWeightLbs * 0.453592).round();
      } else {
        // Convert metric to imperial
        final totalInches = (_selectedHeightCm / 2.54).round();
        _selectedFeet = totalInches ~/ 12;
        _selectedInches = totalInches % 12;
        _selectedWeightLbs = (_selectedWeightKg / 0.453592).round();
      }
      _isMetric = isMetric;

      // Update provider with the new unit system
      ref.read(onboardingProvider.notifier).setUnitSystem(
        isMetric ? UnitSystem.metric : UnitSystem.imperial,
      );

      // Dispose old controllers
      _feetController.dispose();
      _inchesController.dispose();
      _weightController.dispose();

      // Reset controllers
      if (_isMetric) {
        _feetController =
            FixedExtentScrollController(initialItem: _selectedHeightCm - _minHeightCm);
        _inchesController =
            FixedExtentScrollController(initialItem: 0);
        _weightController =
            FixedExtentScrollController(initialItem: _selectedWeightKg - _minWeightKg);
      } else {
        _feetController =
            FixedExtentScrollController(initialItem: _selectedFeet - _minFeet);
        _inchesController =
            FixedExtentScrollController(initialItem: _selectedInches);
        _weightController =
            FixedExtentScrollController(initialItem: _selectedWeightLbs - _minWeightLbs);
      }

      _updateValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Height & weight',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This will be used to calibrate your\ncustom plan.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),

          // Unit toggle
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Imperial',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        !_isMetric ? FontWeight.w600 : FontWeight.w400,
                    color: !_isMetric
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _toggleUnit(!_isMetric),
                  child: Container(
                    width: 52,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _isMetric
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Metric',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        _isMetric ? FontWeight.w600 : FontWeight.w400,
                    color: _isMetric
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Labels
          Row(
            children: [
              Expanded(
                flex: _isMetric ? 1 : 2,
                child: const Text(
                  'Height',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Pickers
          Expanded(
            child: _isMetric ? _buildMetricPickers() : _buildImperialPickers(),
          ),
        ],
      ),
    );
  }

  Widget _buildImperialPickers() {
    return Row(
      children: [
        // Feet picker
        Expanded(
          child: _buildWheelPicker(
            controller: _feetController,
            itemCount: _maxFeet - _minFeet + 1,
            itemBuilder: (index) => '${_minFeet + index} ft',
            onChanged: (index) {
              setState(() {
                _selectedFeet = _minFeet + index;
                _updateValues();
              });
            },
          ),
        ),
        // Inches picker
        Expanded(
          child: _buildWheelPicker(
            controller: _inchesController,
            itemCount: 12,
            itemBuilder: (index) => '$index in',
            onChanged: (index) {
              setState(() {
                _selectedInches = index;
                _updateValues();
              });
            },
          ),
        ),
        // Weight picker (lbs)
        Expanded(
          child: _buildWheelPicker(
            controller: _weightController,
            itemCount: _maxWeightLbs - _minWeightLbs + 1,
            itemBuilder: (index) => '${_minWeightLbs + index} lb',
            onChanged: (index) {
              setState(() {
                _selectedWeightLbs = _minWeightLbs + index;
                _updateValues();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMetricPickers() {
    return Row(
      children: [
        // Height (cm) picker
        Expanded(
          child: _buildWheelPicker(
            controller: _feetController,
            itemCount: _maxHeightCm - _minHeightCm + 1,
            itemBuilder: (index) => '${_minHeightCm + index} cm',
            onChanged: (index) {
              setState(() {
                _selectedHeightCm = _minHeightCm + index;
                _updateValues();
              });
            },
          ),
        ),
        // Weight (kg) picker
        Expanded(
          child: _buildWheelPicker(
            controller: _weightController,
            itemCount: _maxWeightKg - _minWeightKg + 1,
            itemBuilder: (index) => '${_minWeightKg + index} kg',
            onChanged: (index) {
              setState(() {
                _selectedWeightKg = _minWeightKg + index;
                _updateValues();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWheelPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) itemBuilder,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 50,
      perspective: 0.005,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected =
              controller.hasClients && controller.selectedItem == index;
          return Container(
            alignment: Alignment.center,
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Text(
              itemBuilder(index),
              style: TextStyle(
                fontSize: isSelected ? 18 : 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
          );
        },
      ),
    );
  }
}
