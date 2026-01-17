import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/circular_progress_indicator_widget.dart';
import '../../../../shared/widgets/food_entry_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../providers/home_provider.dart';
import '../widgets/week_calendar.dart';
import '../widgets/macro_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDate = ref.watch(selectedDateProvider);
    final dailySummaryAsync = ref.watch(dailySummaryProvider(selectedDate));
    final userGoalsAsync = ref.watch(userGoalsProvider);
    final streakAsync = ref.watch(streakProvider);
    final dailyQuote = _getDailyQuote(l10n);

    // Get goals with defaults
    final userGoals = userGoalsAsync.when(
      data: (goals) => goals,
      loading: () => UserGoals(
        calorieGoal: AppConstants.defaultCalorieGoal,
        proteinGoal: AppConstants.defaultProteinGoal,
        carbsGoal: AppConstants.defaultCarbsGoal,
        fatGoal: AppConstants.defaultFatGoal,
      ),
      error: (_, __) => UserGoals(
        calorieGoal: AppConstants.defaultCalorieGoal,
        proteinGoal: AppConstants.defaultProteinGoal,
        carbsGoal: AppConstants.defaultCarbsGoal,
        fatGoal: AppConstants.defaultFatGoal,
      ),
    );

    // Get streak with default
    final streak = streakAsync.when(
      data: (s) => s,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 28,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.appTitle,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.streak.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 18,
                            color: AppColors.streak,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$streak',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.streak,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Motivational Quote
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.format_quote,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dailyQuote,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimaryColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Week Calendar
            SliverToBoxAdapter(
              child: WeekCalendar(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  ref.read(selectedDateProvider.notifier).state = date;
                },
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: dailySummaryAsync.when(
                data: (summary) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Calories Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${summary.totalCalories}',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: context.textPrimaryColor,
                                          height: 1,
                                        ),
                                      ),
                                      Text(
                                        '/${userGoals.calorieGoal}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: context.textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.caloriesEaten,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: context.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CircularProgressIndicatorWidget(
                              progress: summary.totalCalories / userGoals.calorieGoal,
                              size: 80,
                              strokeWidth: 8,
                              progressColor: AppColors.primary,
                              child: Icon(
                                Icons.local_fire_department,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Macro Cards
                      Row(
                        children: [
                          Expanded(
                            child: MacroCard(
                              label: l10n.proteinEaten,
                              current: summary.totalProtein.toInt(),
                              goal: userGoals.proteinGoal,
                              color: AppColors.protein,
                              icon: Icons.egg_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MacroCard(
                              label: l10n.carbsEaten,
                              current: summary.totalCarbs.toInt(),
                              goal: userGoals.carbsGoal,
                              color: AppColors.carbs,
                              icon: Icons.grass,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MacroCard(
                              label: l10n.fatEaten,
                              current: summary.totalFat.toInt(),
                              goal: userGoals.fatGoal,
                              color: AppColors.fat,
                              icon: Icons.water_drop_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Recently uploaded
                      Text(
                        l10n.recentlyUploaded,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Food Entries
                      if (summary.entries.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: context.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 48,
                                color: context.textTertiaryColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.noMealsLoggedYet,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.tapToAddFirstMeal,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.textTertiaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...summary.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FoodEntryCard(
                            entry: entry,
                            onTap: () {
                              context.push('/food/${entry.id}', extra: {
                                'entry': entry,
                              });
                            },
                            onDelete: () async {
                              try {
                                await ref.read(apiServiceProvider).deleteFoodEntry(entry.id);
                                ref.invalidate(dailySummaryProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.entryDeleted)),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Delete failed: $e')),
                                  );
                                }
                              }
                            },
                          ),
                        )),
                    ],
                  ),
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l10n.errorLoadingData(error.toString()),
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  String _getDailyQuote(AppLocalizations l10n) {
    final quotes = [
      l10n.quote1,
      l10n.quote2,
      l10n.quote3,
      l10n.quote4,
      l10n.quote5,
      l10n.quote6,
      l10n.quote7,
      l10n.quote8,
      l10n.quote9,
      l10n.quote10,
      l10n.quote11,
      l10n.quote12,
      l10n.quote13,
      l10n.quote14,
      l10n.quote15,
    ];
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % quotes.length;
    return quotes[index];
  }
}
