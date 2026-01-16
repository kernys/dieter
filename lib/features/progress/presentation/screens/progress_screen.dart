import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/progress_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentWeight = ref.watch(currentWeightProvider);
    final goalWeight = ref.watch(goalWeightProvider);
    final progressPercentage = ref.watch(progressPercentageProvider);
    final streakDataAsync = ref.watch(streakDataProvider);
    final timeRange = ref.watch(timeRangeProvider);
    final weightLogsAsync = ref.watch(weightLogsProvider);
    final dailyAverageAsync = ref.watch(dailyAverageCaloriesProvider);

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.progress,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
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
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.yourWeight,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currentWeight.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  ' ${l10n.lbs}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.goal(goalWeight.toInt()),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
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
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
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
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
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
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.weightProgress,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
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
                          data: (logs) => _buildChart(logs, ref, l10n),
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

            // Daily Average Calories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyAverageCalories,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${dailyAverage.calories}',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              l10n.cal,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
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

            // Bottom Padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<dynamic> logs, WidgetRef ref, AppLocalizations l10n) {
    if (logs.isEmpty) {
      return Center(child: Text(l10n.noWeightData));
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < logs.length; i++) {
      final log = logs[logs.length - 1 - i];
      spots.add(FlSpot(i.toDouble(), log.weight));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.border,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                final index = value.toInt();
                if (index >= 0 && index < months.length) {
                  return Text(
                    months[index],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary,
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
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.success,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.success,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.success.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} lbs',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        minY: 115,
        maxY: 145,
      ),
    );
  }

  void _showLogWeightDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logWeight),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.weightLbs,
            hintText: l10n.enterYourWeight,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save weight to Supabase
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.weightLogged)),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
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
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
