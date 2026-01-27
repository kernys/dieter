import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Determines the ring style based on calorie status
enum CalorieRingStyle {
  /// Green - under 80% of goal
  onTrack,
  /// Yellow - 80-100% of goal
  approaching,
  /// Red - over goal
  over,
  /// Dotted - no data or goal not set
  inactive,
}

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Widget? child;
  final bool useDottedStyle;
  final CalorieRingStyle? ringStyle;

  const CircularProgressIndicatorWidget({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 12,
    this.progressColor = AppColors.primary,
    this.backgroundColor = AppColors.progressBackground,
    this.child,
    this.useDottedStyle = false,
    this.ringStyle,
  });

  /// Get color based on ring style
  Color _getColorForStyle(CalorieRingStyle style) {
    switch (style) {
      case CalorieRingStyle.onTrack:
        return const Color(0xFF4CAF50); // Green
      case CalorieRingStyle.approaching:
        return const Color(0xFFFFC107); // Yellow/Amber
      case CalorieRingStyle.over:
        return const Color(0xFFF44336); // Red
      case CalorieRingStyle.inactive:
        return AppColors.textTertiary;
    }
  }

  /// Determine ring style based on calories consumed vs goal
  static CalorieRingStyle determineRingStyle({
    required double consumed,
    required double goal,
    required bool hasData,
  }) {
    if (!hasData || goal <= 0) {
      return CalorieRingStyle.inactive;
    }
    
    final percentage = consumed / goal;
    
    if (percentage > 1.0) {
      return CalorieRingStyle.over;
    } else if (percentage >= 0.8) {
      return CalorieRingStyle.approaching;
    } else {
      return CalorieRingStyle.onTrack;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = ringStyle != null 
        ? _getColorForStyle(ringStyle!) 
        : progressColor;
    final isDotted = useDottedStyle || ringStyle == CalorieRingStyle.inactive;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: isDotted ? 0.0 : progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              progressColor: effectiveColor,
              backgroundColor: backgroundColor,
              useDottedStyle: isDotted,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final bool useDottedStyle;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    this.useDottedStyle = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    if (useDottedStyle) {
      // Draw dotted circle
      final dottedPaint = Paint()
        ..color = progressColor.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const dashCount = 24;
      const dashLength = 0.8; // Ratio of dash vs gap
      final dashAngle = (2 * math.pi / dashCount) * dashLength;
      final gapAngle = (2 * math.pi / dashCount) * (1 - dashLength);

      for (int i = 0; i < dashCount; i++) {
        final startAngle = -math.pi / 2 + i * (dashAngle + gapAngle);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          dashAngle,
          false,
          dottedPaint,
        );
      }
    } else {
      // Background circle
      final backgroundPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius, backgroundPaint);

      // Progress arc
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.useDottedStyle != useDottedStyle;
  }
}

class MacroProgressWidget extends StatelessWidget {
  final String label;
  final int current;
  final int goal;
  final Color color;
  final IconData? icon;

  const MacroProgressWidget({
    super.key,
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? current / goal : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$current',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '/${goal}g',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          CircularProgressIndicatorWidget(
            progress: progress,
            size: 60,
            strokeWidth: 6,
            progressColor: color,
            child: icon != null
                ? Icon(icon, color: color, size: 20)
                : null,
          ),
        ],
      ),
    );
  }
}
