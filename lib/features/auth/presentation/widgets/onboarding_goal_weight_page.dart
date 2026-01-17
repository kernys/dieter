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
  late ScrollController _scrollController;
  double _selectedWeight = 120.0;

  static const double _minWeight = 60.0;
  static const double _maxWeight = 300.0;
  static const double _tickWidth = 10.0;
  static const double _majorTickInterval = 10.0;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.goalWeight != null) {
      _selectedWeight = onboardingState.goalWeight!;
    } else if (onboardingState.currentWeight != null) {
      // Default to current weight - 10 lbs as goal
      _selectedWeight = (onboardingState.currentWeight! - 10).clamp(_minWeight, _maxWeight);
    }

    final initialOffset =
        (_selectedWeight - _minWeight) * _tickWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateGoalWeight();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final weight = _minWeight + (offset / _tickWidth);
    final clampedWeight = weight.clamp(_minWeight, _maxWeight);

    if ((clampedWeight - _selectedWeight).abs() >= 0.1) {
      setState(() {
        _selectedWeight = (clampedWeight * 10).round() / 10;
      });
      _updateGoalWeight();
    }
  }

  void _updateGoalWeight() {
    ref.read(onboardingProvider.notifier).setGoalWeight(_selectedWeight);
  }

  String _getWeightLabel() {
    final currentWeight = ref.read(onboardingProvider).currentWeight;
    if (currentWeight == null) return '';

    if (_selectedWeight < currentWeight) {
      return 'Lose weight';
    } else if (_selectedWeight > currentWeight) {
      return 'Gain weight';
    } else {
      return 'Maintain weight';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                      const TextSpan(
                        text: ' lbs',
                        style: TextStyle(
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

          // Ruler
          SizedBox(
            height: 80,
            child: Stack(
              children: [
                // Scrollable ruler
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) => true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      width: (_maxWeight - _minWeight) * _tickWidth +
                          screenWidth,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth / 2),
                      child: CustomPaint(
                        size: Size(
                          (_maxWeight - _minWeight) * _tickWidth,
                          80,
                        ),
                        painter: _RulerPainter(
                          minValue: _minWeight,
                          maxValue: _maxWeight,
                          tickWidth: _tickWidth,
                          majorTickInterval: _majorTickInterval,
                          selectedValue: _selectedWeight,
                        ),
                      ),
                    ),
                  ),
                ),

                // Center indicator
                Positioned(
                  left: screenWidth / 2 - 24 - 1,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: AppColors.primary,
                  ),
                ),

                // Gradient overlay left
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth * 0.3,
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

                // Gradient overlay right
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: screenWidth * 0.3,
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
              ],
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

  _RulerPainter({
    required this.minValue,
    required this.maxValue,
    required this.tickWidth,
    required this.majorTickInterval,
    required this.selectedValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

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
        tickHeight = 40;
        paint.color = isNearSelected
            ? AppColors.textPrimary
            : AppColors.textTertiary.withValues(alpha: 0.5);
      } else if (isMinorMajorTick) {
        tickHeight = 28;
        paint.color = isNearSelected
            ? AppColors.textSecondary
            : AppColors.textTertiary.withValues(alpha: 0.3);
      } else {
        tickHeight = 16;
        paint.color = isNearSelected
            ? AppColors.textTertiary
            : AppColors.textTertiary.withValues(alpha: 0.2);
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
    return oldDelegate.selectedValue != selectedValue;
  }
}
