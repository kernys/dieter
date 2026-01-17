import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingGoalWeightPage extends ConsumerStatefulWidget {
  const OnboardingGoalWeightPage({super.key});

  @override
  ConsumerState<OnboardingGoalWeightPage> createState() =>
      _OnboardingGoalWeightPageState();
}

class _OnboardingGoalWeightPageState
    extends ConsumerState<OnboardingGoalWeightPage> {
  ScrollController? _scrollController;
  double _selectedWeight = 70.0;
  bool _isMetric = false;
  bool _initialized = false;

  // Imperial ranges (lbs)
  static const double _minWeightLbs = 60.0;
  static const double _maxWeightLbs = 400.0;

  // Metric ranges (kg)
  static const double _minWeightKg = 30.0;
  static const double _maxWeightKg = 180.0;

  static const double _tickWidth = 12.0;

  double get _minWeight => _isMetric ? _minWeightKg : _minWeightLbs;
  double get _maxWeight => _isMetric ? _maxWeightKg : _maxWeightLbs;
  double get _majorTickInterval => 10.0;
  String get _unit => _isMetric ? 'kg' : 'lbs';

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _scrollController?.dispose();
    super.dispose();
  }

  void _initializeWithUnitSystem(OnboardingState onboardingState) {
    final newIsMetric = onboardingState.unitSystem == UnitSystem.metric;

    // If unit system changed or not initialized, reinitialize
    if (!_initialized || newIsMetric != _isMetric) {
      _isMetric = newIsMetric;

      // Calculate initial weight
      double initialWeight;
      if (_isMetric) {
        if (onboardingState.currentWeightKg != null) {
          initialWeight = (onboardingState.currentWeightKg! - 5).clamp(_minWeightKg, _maxWeightKg);
        } else {
          initialWeight = 65.0; // Default 65kg
        }
      } else {
        if (onboardingState.currentWeight != null) {
          initialWeight = (onboardingState.currentWeight! - 10).clamp(_minWeightLbs, _maxWeightLbs);
        } else {
          initialWeight = 140.0; // Default 140lbs
        }
      }

      _selectedWeight = initialWeight;

      // Dispose old controller
      _scrollController?.removeListener(_onScroll);
      _scrollController?.dispose();

      // Create new controller
      final initialOffset = (_selectedWeight - _minWeight) * _tickWidth;
      _scrollController = ScrollController(initialScrollOffset: initialOffset);
      _scrollController!.addListener(_onScroll);

      _initialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateGoalWeight();
      });
    }
  }

  void _onScroll() {
    if (_scrollController == null) return;

    final offset = _scrollController!.offset;
    final weight = _minWeight + (offset / _tickWidth);
    final clampedWeight = weight.clamp(_minWeight, _maxWeight);

    if ((clampedWeight - _selectedWeight).abs() >= 0.5) {
      setState(() {
        _selectedWeight = (clampedWeight * 2).round() / 2;
      });
      _updateGoalWeight();
    }
  }

  void _updateGoalWeight() {
    ref.read(onboardingProvider.notifier).setGoalWeight(_selectedWeight);
  }

  String _getWeightLabel() {
    final onboardingState = ref.read(onboardingProvider);
    double? currentWeight;

    if (_isMetric) {
      currentWeight = onboardingState.currentWeightKg;
    } else {
      currentWeight = onboardingState.currentWeight;
    }

    if (currentWeight == null) return '';

    if (_selectedWeight < currentWeight - 1) {
      return 'Lose weight';
    } else if (_selectedWeight > currentWeight + 1) {
      return 'Gain weight';
    } else {
      return 'Maintain weight';
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Initialize or update based on unit system
    _initializeWithUnitSystem(onboardingState);

    if (_scrollController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'What is your\ndesired weight?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const Spacer(),

          // Weight label
          Center(
            child: Column(
              children: [
                Text(
                  _getWeightLabel(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _selectedWeight.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' $_unit',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Ruler - expanded touch area
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              final newOffset = _scrollController!.offset - details.delta.dx;
              _scrollController!.jumpTo(
                newOffset.clamp(0, (_maxWeight - _minWeight) * _tickWidth),
              );
            },
            child: SizedBox(
              height: 120,
              child: Stack(
                children: [
                  // Scrollable ruler
                  Positioned.fill(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        width: (_maxWeight - _minWeight) * _tickWidth + screenWidth,
                        padding: EdgeInsets.symmetric(horizontal: screenWidth / 2),
                        child: CustomPaint(
                          size: Size(
                            (_maxWeight - _minWeight) * _tickWidth,
                            120,
                          ),
                          painter: _RulerPainter(
                            minValue: _minWeight,
                            maxValue: _maxWeight,
                            tickWidth: _tickWidth,
                            majorTickInterval: _majorTickInterval,
                            selectedValue: _selectedWeight,
                            isMetric: _isMetric,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Center indicator
                  Positioned(
                    left: screenWidth / 2 - 24 - 1,
                    top: 20,
                    bottom: 20,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Gradient overlay left
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.background,
                              AppColors.background.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Gradient overlay right
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              AppColors.background,
                              AppColors.background.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double minValue;
  final double maxValue;
  final double tickWidth;
  final double majorTickInterval;
  final double selectedValue;
  final bool isMetric;

  _RulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.tickWidth,
    required this.majorTickInterval,
    required this.selectedValue,
    required this.isMetric,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final totalTicks = ((maxValue - minValue) * 2).toInt();
    final centerY = size.height / 2;

    for (int i = 0; i <= totalTicks; i++) {
      final value = minValue + i * 0.5;
      final x = (value - minValue) * tickWidth;

      final isMajorTick = value % majorTickInterval == 0;
      final isMinorMajorTick = value % 5 == 0 && !isMajorTick;
      final distanceFromSelected = (value - selectedValue).abs();
      final isNearSelected = distanceFromSelected < 15;

      double tickHeight;
      if (isMajorTick) {
        tickHeight = 50;
        paint.color = isNearSelected
            ? AppColors.textPrimary
            : AppColors.textTertiary.withValues(alpha: 0.5);
        paint.strokeWidth = 2.5;

        // Draw label for major ticks
        textPainter.text = TextSpan(
          text: value.toInt().toString(),
          style: TextStyle(
            fontSize: 12,
            color: isNearSelected
                ? AppColors.textPrimary
                : AppColors.textTertiary.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, centerY + tickHeight / 2 + 8),
        );
      } else if (isMinorMajorTick) {
        tickHeight = 35;
        paint.color = isNearSelected
            ? AppColors.textSecondary
            : AppColors.textTertiary.withValues(alpha: 0.3);
        paint.strokeWidth = 2;
      } else {
        tickHeight = 20;
        paint.color = isNearSelected
            ? AppColors.textTertiary
            : AppColors.textTertiary.withValues(alpha: 0.2);
        paint.strokeWidth = 1.5;
      }

      canvas.drawLine(
        Offset(x, centerY - tickHeight / 2),
        Offset(x, centerY + tickHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    return oldDelegate.selectedValue != selectedValue ||
        oldDelegate.isMetric != isMetric ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue;
  }
}
