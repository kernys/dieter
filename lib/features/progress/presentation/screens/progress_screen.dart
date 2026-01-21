import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/settings_provider.dart';
import '../providers/progress_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  // Helper to convert weight based on unit system
  double _convertWeight(double weightInLbs, UnitSystem unitSystem) {
    if (unitSystem == UnitSystem.metric) {
      return weightInLbs * 0.453592;
    }
    return weightInLbs;
  }

  String _getWeightUnit(UnitSystem unitSystem, AppLocalizations l10n) {
    return unitSystem == UnitSystem.metric ? l10n.kg : l10n.lbs;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final currentWeight = ref.watch(currentWeightProvider);
    final goalWeight = ref.watch(goalWeightProvider);
    final progressPercentage = ref.watch(progressPercentageProvider);
    final streakDataAsync = ref.watch(streakDataProvider);
    final timeRange = ref.watch(timeRangeProvider);
    final weightLogsAsync = ref.watch(weightLogsProvider);
    final dailyAverageAsync = ref.watch(dailyAverageCaloriesProvider);

    // Convert weights based on unit system
    final displayWeight = _convertWeight(currentWeight, settings.unitSystem);
    final displayGoalWeight = _convertWeight(goalWeight, settings.unitSystem);
    final weightUnit = _getWeightUnit(settings.unitSystem, l10n);

    // Get streak data with defaults
    final streakData = streakDataAsync.when(
      data: (data) => data,
      loading: () => StreakData(currentStreak: 0, weekData: List.filled(7, false)),
      error: (_, __) => StreakData(currentStreak: 0, weekData: List.filled(7, false)),
    );

    // Get daily average with defaults
    final dailyAverage = dailyAverageAsync.when(
      data: (data) => data,
      loading: () => DailyAverageData(calories: 0, changePercentage: 0, isIncrease: false),
      error: (_, __) => DailyAverageData(calories: 0, changePercentage: 0, isIncrease: false),
    );

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.progress,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
            ),

            // Weight and Streak Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Weight Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.yourWeight,
                              style: TextStyle(
                                fontSize: 14,
                                color: context.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  displayWeight.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimaryColor,
                                  ),
                                ),
                                Text(
                                  ' $weightUnit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: context.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () => _showEditGoalWeightDialog(context, ref, l10n, settings, goalWeight),
                              child: Row(
                                children: [
                                  Text(
                                    settings.unitSystem == UnitSystem.metric
                                        ? l10n.goalKg(displayGoalWeight.toInt())
                                        : l10n.goal(goalWeight.toInt()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.edit,
                                    size: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _showLogWeightDialog(context, ref, l10n),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 40),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(l10n.logWeight),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Streak Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: AppColors.streak,
                                  size: 28,
                                ),
                                Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.streak.withValues(alpha: 0.6),
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${streakData.currentStreak}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimaryColor,
                              ),
                            ),
                            Text(
                              l10n.dayStreak,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.streak,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Week indicators
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final isCompleted = entry.key < streakData.weekData.length &&
                                    streakData.weekData[entry.key];
                                return Column(
                                  children: [
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isCompleted
                                            ? AppColors.streak
                                            : AppColors.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.success
                                            : AppColors.progressBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: isCompleted
                                          ? const Icon(
                                              Icons.check,
                                              size: 12,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Weight Progress Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.weightProgress,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimaryColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.flag, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.percentOfGoal(progressPercentage.toInt()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Chart
                      SizedBox(
                        height: 200,
                        child: weightLogsAsync.when(
                          data: (logs) => _buildChart(logs, ref, l10n, settings, weightUnit),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (_, __) => Center(
                            child: Text(l10n.errorLoadingDataSimple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Time Range Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TimeRangeButton(
                            label: l10n.range90d,
                            isSelected: timeRange == TimeRange.days90,
                            onPressed: () {
                              ref.read(timeRangeProvider.notifier).state =
                                  TimeRange.days90;
                            },
                          ),
                          _TimeRangeButton(
                            label: l10n.range6m,
                            isSelected: timeRange == TimeRange.months6,
                            onPressed: () {
                              ref.read(timeRangeProvider.notifier).state =
                                  TimeRange.months6;
                            },
                          ),
                          _TimeRangeButton(
                            label: l10n.range1y,
                            isSelected: timeRange == TimeRange.year1,
                            onPressed: () {
                              ref.read(timeRangeProvider.notifier).state =
                                  TimeRange.year1;
                            },
                          ),
                          _TimeRangeButton(
                            label: l10n.rangeAll,
                            isSelected: timeRange == TimeRange.all,
                            onPressed: () {
                              ref.read(timeRangeProvider.notifier).state =
                                  TimeRange.all;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Motivational message
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.greatJobConsistency,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Weight Changes Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.weightChanges,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _WeightChangeRow(period: l10n.day3, change: 0.0, isIncrease: null),
                      _WeightChangeRow(period: l10n.day7, change: 0.0, isIncrease: null),
                      _WeightChangeRow(period: l10n.day14, change: 0.0, isIncrease: null),
                      _WeightChangeRow(period: l10n.day30, change: 1.0, isIncrease: true),
                      _WeightChangeRow(period: l10n.day90, change: 1.0, isIncrease: true),
                      _WeightChangeRow(period: l10n.allTime, change: 1.0, isIncrease: true),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Daily Average Calories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyAverageCalories,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${dailyAverage.calories}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              l10n.cal,
                              style: TextStyle(
                                fontSize: 16,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: dailyAverage.isIncrease
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  dailyAverage.isIncrease
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 12,
                                  color: dailyAverage.isIncrease
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                                Text(
                                  '${dailyAverage.changePercentage}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: dailyAverage.isIncrease
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Weekly Energy Chart
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.weeklyEnergy,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _WeeklyEnergySummary(l10n: l10n),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _WeeklyEnergyChart(l10n: l10n),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // BMI Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: _BMICard(
                    currentWeight: displayWeight,
                    weightUnit: weightUnit,
                    l10n: l10n,
                    settings: settings,
                  ),
                ),
              ),
            ),

            // Bottom Padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<dynamic> logs, WidgetRef ref, AppLocalizations l10n, AppSettings settings, String weightUnit) {
    if (logs.isEmpty) {
      return Center(child: Text(l10n.noWeightData));
    }

    final isMetric = settings.unitSystem == UnitSystem.metric;
    final goalWeightRaw = ref.watch(goalWeightProvider);
    final goalWeight = isMetric ? goalWeightRaw * 0.453592 : goalWeightRaw;

    final spots = <FlSpot>[];
    double minWeight = double.infinity;
    double maxWeight = double.negativeInfinity;

    for (var i = 0; i < logs.length; i++) {
      final log = logs[logs.length - 1 - i];
      // Convert to kg if metric
      final weight = isMetric ? log.weight * 0.453592 : log.weight;
      spots.add(FlSpot(i.toDouble(), weight));
      if (weight < minWeight) minWeight = weight;
      if (weight > maxWeight) maxWeight = weight;
    }

    // Include goal weight in min/max calculation
    if (goalWeight < minWeight) minWeight = goalWeight;
    if (goalWeight > maxWeight) maxWeight = goalWeight;

    // Add padding to min/max
    final padding = (maxWeight - minWeight) * 0.2;
    final chartMinY = (minWeight - padding).clamp(0.0, double.infinity);
    final chartMaxY = maxWeight + padding;
    final interval = ((chartMaxY - chartMinY) / 4).ceilToDouble().clamp(1.0, double.infinity);

    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: goalWeight,
              color: AppColors.success,
              strokeWidth: 2,
              dashArray: [8, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
                labelResolver: (line) => '${l10n.goalWeight}: ${goalWeight.toStringAsFixed(1)}',
              ),
            ),
          ],
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.border.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: interval,
              getTitlesWidget: (value, meta) {
                // Avoid showing the first/last value if it's at the edge
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: logs.length > 6 ? (logs.length / 6).ceilToDouble() : 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < logs.length) {
                  final log = logs[logs.length - 1 - index];
                  final date = log.recordedAt;
                  final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      monthNames[date.month - 1],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        clipData: const FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                // Show larger dot for last point (most recent)
                final isLast = index == spots.length - 1;
                return FlDotCirclePainter(
                  radius: isLast ? 5 : 3,
                  color: AppColors.primary,
                  strokeWidth: isLast ? 2 : 1.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.spotIndex;
                final logIndex = logs.length - 1 - index;
                final log = logs[logIndex];
                final date = log.recordedAt;
                final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} $weightUnit\n${monthNames[date.month - 1]} ${date.day}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                );
              }).toList();
            },
          ),
        ),
        minY: chartMinY,
        maxY: chartMaxY,
      ),
    );
  }

  void _showLogWeightDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final controller = TextEditingController();
    final settings = ref.read(settingsProvider);
    final isMetric = settings.unitSystem == UnitSystem.metric;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logWeight),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: isMetric ? l10n.weightKg : l10n.weightLbs,
            hintText: l10n.enterYourWeight,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final inputWeight = double.tryParse(controller.text);
              if (inputWeight != null && inputWeight > 0) {
                // Convert to lbs if input is in kg (API stores in lbs)
                final weightInLbs = isMetric ? inputWeight / 0.453592 : inputWeight;
                try {
                  await ref.read(
                    addWeightLogProvider(AddWeightLogParams(weight: weightInLbs)).future,
                  );

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.weightLogged)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    final errorMessage = e.toString().replaceFirst('Exception: ', '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showEditGoalWeightDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, AppSettings settings, double currentGoalWeight) {
    final controller = TextEditingController();
    final isMetric = settings.unitSystem == UnitSystem.metric;
    final displayWeight = isMetric ? currentGoalWeight * 0.453592 : currentGoalWeight;
    controller.text = displayWeight.toStringAsFixed(1);

    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, dialogRef, child) => AlertDialog(
        title: Text(l10n.goalWeight),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: isMetric ? l10n.weightKg : l10n.weightLbs,
            hintText: l10n.enterGoalWeight,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final inputWeight = double.tryParse(controller.text);
              if (inputWeight != null && inputWeight > 0) {
                // Convert to lbs if input is in kg (API stores in lbs)
                final weightInLbs = isMetric ? inputWeight / 0.453592 : inputWeight;
                try {
                  // Check if user is in guest mode
                  final authState = dialogRef.read(authStateProvider);
                  if (authState.isGuestMode) {
                    // For guest mode, just show message
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
                      );
                    }
                    return;
                  }

                  // Update goal weight on server
                  await dialogRef.read(authStateProvider.notifier).updateUser({
                    'goalWeight': weightInLbs,
                  });

                  // Verify the update was successful
                  final updatedUser = dialogRef.read(authStateProvider).user;
                  debugPrint('Goal weight updated: ${updatedUser?.goalWeight}');

                  // Refresh all related providers
                  dialogRef.invalidate(weightLogsResponseProvider);

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${l10n.goalWeightUpdated} (${updatedUser?.goalWeight?.toStringAsFixed(1)} lbs)')),
                    );
                  }
                } catch (e) {
                  debugPrint('Goal weight update error: $e');
                  if (context.mounted) {
                    final errorMessage = e.toString().replaceFirst('Exception: ', '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $errorMessage')),
                    );
                  }
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      )),
    );
  }

}

class _TimeRangeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TimeRangeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : context.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}

class _WeightChangeRow extends ConsumerWidget {
  final String period;
  final double change;
  final bool? isIncrease;

  const _WeightChangeRow({
    required this.period,
    required this.change,
    required this.isIncrease,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final isMetric = settings.unitSystem == UnitSystem.metric;
    final weightUnit = isMetric ? l10n.kg : l10n.lbs;
    final displayChange = isMetric ? change * 0.453592 : change;

    String changeText;
    String statusText;
    Color statusColor;
    IconData? statusIcon;

    if (isIncrease == null || change == 0) {
      changeText = '0.0 $weightUnit';
      statusText = l10n.noChange;
      statusColor = AppColors.textSecondary;
      statusIcon = Icons.arrow_forward;
    } else if (isIncrease!) {
      changeText = '${displayChange.toStringAsFixed(1)} $weightUnit';
      statusText = l10n.increase;
      statusColor = AppColors.error;
      statusIcon = Icons.arrow_outward;
    } else {
      changeText = '${displayChange.toStringAsFixed(1)} $weightUnit';
      statusText = l10n.decrease;
      statusColor = AppColors.success;
      statusIcon = Icons.arrow_downward;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              period,
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Progress bar
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: context.isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: change > 0 ? 0.6 : 0.2,
              child: Container(
                decoration: BoxDecoration(
                  color: change > 0
                      ? (isIncrease == true ? AppColors.error.withValues(alpha: 0.7) : AppColors.success.withValues(alpha: 0.7))
                      : (context.isDark ? const Color(0xFF4A4A4C) : const Color(0xFFD0D0D0)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: Text(
              changeText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          const Spacer(),
          Icon(
            statusIcon,
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 14,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyEnergySummary extends ConsumerWidget {
  final AppLocalizations l10n;

  const _WeeklyEnergySummary({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyEnergyAsync = ref.watch(weeklyEnergyDataProvider);

    return weeklyEnergyAsync.when(
      data: (data) {
        final burnedCalories = data.totalBurned;
        final consumedCalories = data.totalConsumed;
        final netEnergy = consumedCalories - burnedCalories;

        return Row(
          children: [
            _EnergyStat(
              label: l10n.burned,
              value: burnedCalories,
              color: AppColors.streak,
            ),
            const SizedBox(width: 24),
            _EnergyStat(
              label: l10n.consumed,
              value: consumedCalories,
              color: AppColors.success,
            ),
            const SizedBox(width: 24),
            _EnergyStat(
              label: l10n.energy,
              value: netEnergy,
              color: netEnergy >= 0 ? AppColors.success : AppColors.error,
              showSign: true,
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => Row(
        children: [
          _EnergyStat(
            label: l10n.burned,
            value: 0,
            color: AppColors.streak,
          ),
          const SizedBox(width: 24),
          _EnergyStat(
            label: l10n.consumed,
            value: 0,
            color: AppColors.success,
          ),
          const SizedBox(width: 24),
          _EnergyStat(
            label: l10n.energy,
            value: 0,
            color: AppColors.success,
            showSign: true,
          ),
        ],
      ),
    );
  }
}

class _EnergyStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool showSign;

  const _EnergyStat({
    required this.label,
    required this.value,
    required this.color,
    this.showSign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              showSign && value > 0 ? '+$value' : '$value',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                'cal',
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeeklyEnergyChart extends ConsumerWidget {
  final AppLocalizations l10n;

  const _WeeklyEnergyChart({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyEnergyAsync = ref.watch(weeklyEnergyDataProvider);
    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return weeklyEnergyAsync.when(
      data: (data) {
        final burnedData = data.burnedData;
        final consumedData = data.consumedData;
        final maxY = consumedData.reduce((a, b) => a > b ? a : b).toDouble();
        final chartMaxY = maxY > 0 ? (maxY * 1.2).ceilToDouble() : 1000.0;
        final interval = (chartMaxY / 4).ceilToDouble().clamp(100.0, double.infinity);

        return Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: chartMaxY,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weekDays.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                weekDays[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: interval,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: context.textTertiaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: context.borderColor,
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: burnedData[index].toDouble(),
                          color: AppColors.streak,
                          width: 8,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                        BarChartRodData(
                          toY: consumedData[index].toDouble(),
                          color: AppColors.success,
                          width: 8,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(color: AppColors.streak, label: l10n.burned),
                const SizedBox(width: 24),
                _LegendItem(color: AppColors.success, label: l10n.consumed),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text(
          l10n.errorLoadingDataSimple,
          style: TextStyle(color: context.textSecondaryColor),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}

class _BMICard extends StatelessWidget {
  final double currentWeight;
  final String weightUnit;
  final AppLocalizations l10n;
  final AppSettings settings;

  const _BMICard({
    required this.currentWeight,
    required this.weightUnit,
    required this.l10n,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    // Get height from settings (default 170cm if not set)
    final heightCm = settings.heightCm ?? 170.0;
    final heightM = heightCm / 100;

    // Calculate BMI: weight(kg) / height(m)^2
    final weightKg = settings.unitSystem == UnitSystem.metric
        ? currentWeight
        : currentWeight * 0.453592;
    final bmi = weightKg / (heightM * heightM);

    String bmiCategory;
    Color bmiColor;

    if (bmi < 18.5) {
      bmiCategory = l10n.bmiUnderweight;
      bmiColor = AppColors.warning;
    } else if (bmi < 25) {
      bmiCategory = l10n.bmiNormal;
      bmiColor = AppColors.success;
    } else if (bmi < 30) {
      bmiCategory = l10n.bmiOverweight;
      bmiColor = AppColors.warning;
    } else {
      bmiCategory = l10n.bmiObese;
      bmiColor = AppColors.error;
    }

    // Calculate position on scale matching label positions
    // Labels at equal spacing: 15, 18.5, 25, 30, 40 (positions 0, 0.25, 0.5, 0.75, 1.0)
    double bmiPosition;
    if (bmi <= 15) {
      bmiPosition = 0.0;
    } else if (bmi <= 18.5) {
      // 15-18.5 maps to 0-0.25
      bmiPosition = ((bmi - 15) / 3.5) * 0.25;
    } else if (bmi <= 25) {
      // 18.5-25 maps to 0.25-0.5
      bmiPosition = 0.25 + ((bmi - 18.5) / 6.5) * 0.25;
    } else if (bmi <= 30) {
      // 25-30 maps to 0.5-0.75
      bmiPosition = 0.5 + ((bmi - 25) / 5) * 0.25;
    } else if (bmi <= 40) {
      // 30-40 maps to 0.75-1.0
      bmiPosition = 0.75 + ((bmi - 30) / 10) * 0.25;
    } else {
      bmiPosition = 1.0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.yourBMI,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
            Text(
              '${l10n.height}: ${heightCm.toInt()}cm',
              style: TextStyle(
                fontSize: 12,
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bmiColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bmiCategory,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: bmiColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // BMI Scale
        LayoutBuilder(
          builder: (context, constraints) {
            final scaleWidth = constraints.maxWidth;
            return Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF64B5F6), // Underweight (< 18.5)
                        Color(0xFF4CAF50), // Normal (18.5-25)
                        Color(0xFFFFB74D), // Overweight (25-30)
                        Color(0xFFE57373), // Obese (>= 30)
                      ],
                      // Labels at 0, 0.25, 0.5, 0.75, 1.0 (15, 18.5, 25, 30, 40)
                      stops: [0.0, 0.25, 0.5, 0.75],
                    ),
                  ),
                ),
                Positioned(
                  left: (bmiPosition * scaleWidth - 8).clamp(0.0, scaleWidth - 16),
                  top: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: bmiColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('15', style: TextStyle(fontSize: 10, color: context.textTertiaryColor)),
            Text('18.5', style: TextStyle(fontSize: 10, color: context.textTertiaryColor)),
            Text('25', style: TextStyle(fontSize: 10, color: context.textTertiaryColor)),
            Text('30', style: TextStyle(fontSize: 10, color: context.textTertiaryColor)),
            Text('40', style: TextStyle(fontSize: 10, color: context.textTertiaryColor)),
          ],
        ),
      ],
    );
  }
}
