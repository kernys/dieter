import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/circular_progress_indicator_widget.dart';
import '../../../../shared/widgets/food_entry_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../exercise/presentation/providers/exercise_log_provider.dart';
import '../providers/home_provider.dart';
import '../providers/role_model_provider.dart';
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
    final roleModelImage = ref.watch(roleModelProvider);
    final pendingFoodEntries = ref.watch(pendingFoodEntriesProvider);
    
    // Watch widget updater to keep home screen widget in sync
    ref.watch(widgetUpdaterProvider);
    
    // Watch Apple Health data
    final healthDataAsync = ref.watch(healthDataProvider);
    final healthData = healthDataAsync.when(
      data: (data) => data,
      loading: () => const HealthData(steps: 0, activeCaloriesBurned: 0, isConnected: false),
      error: (_, __) => const HealthData(steps: 0, activeCaloriesBurned: 0, isConnected: false),
    );

    // Get exercise logs for selected date
    final allExerciseLogs = ref.watch(exerciseLogProvider);
    final exerciseLogsForDate = allExerciseLogs.where((log) =>
      log.loggedAt.year == selectedDate.year &&
      log.loggedAt.month == selectedDate.month &&
      log.loggedAt.day == selectedDate.day
    ).toList();
    final manualBurnedCalories = exerciseLogsForDate.fold(0, (sum, log) => sum + log.caloriesBurned);
    
    // Total burned = Apple Health active calories + manual exercise logs
    final burnedCalories = healthData.activeCaloriesBurned + manualBurnedCalories;

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

            // Role Model Image
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => _showRoleModelOptions(context, ref, l10n),
                  onLongPress: roleModelImage != null
                      ? () => _showRoleModelOptions(context, ref, l10n)
                      : null,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: roleModelImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                _buildRoleModelImage(roleModelImage),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.5),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Text(
                                    l10n.roleModelMotivation,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 36,
                                color: context.textTertiaryColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.addRoleModel,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Week Calendar
            SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  final weekDatesWithData = ref.watch(weekDatesWithDataProvider);
                  return WeekCalendar(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      ref.read(selectedDateProvider.notifier).state = date;
                    },
                    datesWithData: weekDatesWithData.valueOrNull,
                  );
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
                                        '${(summary.totalCalories - burnedCalories).clamp(0, double.infinity).toInt()}',
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
                                  Row(
                                    children: [
                                      Text(
                                        '${summary.totalCalories}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: context.textSecondaryColor,
                                        ),
                                      ),
                                      Text(
                                        ' ${l10n.caloriesEaten}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: context.textSecondaryColor,
                                        ),
                                      ),
                                      if (burnedCalories > 0) ...[
                                        Text(
                                          ' - $burnedCalories ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.fitness_center,
                                          size: 12,
                                          color: AppColors.success,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CircularProgressIndicatorWidget(
                              progress: (summary.totalCalories - burnedCalories).clamp(0, double.infinity) / userGoals.calorieGoal,
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
                      
                      // Apple Health Stats (Steps & Activity)
                      if (healthData.isConnected) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: context.borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.directions_walk,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.steps,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: context.textSecondaryColor,
                                            ),
                                          ),
                                          Text(
                                            '${healthData.steps}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: context.textPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: context.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: context.borderColor),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.local_fire_department,
                                        color: AppColors.success,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.burned,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: context.textSecondaryColor,
                                            ),
                                          ),
                                          Text(
                                            '$burnedCalories ${l10n.cal}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: context.textPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

                      // Exercise Entries
                      ...exerciseLogsForDate.map((exerciseLog) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildExerciseCard(context, l10n, ref, exerciseLog),
                      )),

                      // Food Entries
                      if (summary.entries.isEmpty && exerciseLogsForDate.isEmpty)
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
                      else ...[
                        // Show pending food entries being registered
                        ...pendingFoodEntries.map((pendingId) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.registeringFood,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: context.textSecondaryColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        // Show registered food entries
                        ...summary.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FoodEntryCard(
                            entry: entry,
                            onTap: () {
                              context.push('/food/${entry.id}', extra: {
                                'entry': entry,
                              });
                            },
                            // Remove onDelete - users can delete from detail screen
                          ),
                        )),
                      ],
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

  void _showRoleModelOptions(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final hasImage = ref.read(roleModelProvider) != null;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.roleModel,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text(l10n.chooseFromGallery),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(context, ref, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(l10n.takePhoto),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(context, ref, ImageSource.camera);
                },
              ),
              if (hasImage)
                ListTile(
                  leading: const Icon(Icons.delete, color: AppColors.error),
                  title: Text(l10n.removePhoto, style: const TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(roleModelProvider.notifier).removeImage();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, maxWidth: 1200, maxHeight: 1200);

    if (pickedFile != null) {
      // Copy to app documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'role_model_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${appDir.path}/$fileName';

      await File(pickedFile.path).copy(savedPath);
      ref.read(roleModelProvider.notifier).setImage(savedPath);
    }
  }

  Widget _buildRoleModelImage(String imageSource) {
    // Check if it's a URL or local file path
    if (imageSource.startsWith('http://') || imageSource.startsWith('https://')) {
      return Image.network(
        imageSource,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 48),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return Image.file(
        File(imageSource),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 48),
          );
        },
      );
    }
  }

  Widget _buildExerciseCard(BuildContext context, AppLocalizations l10n, WidgetRef ref, ExerciseLog exerciseLog) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fitness_center,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseLog.type,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${exerciseLog.duration} min',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondaryColor,
                      ),
                    ),
                    if (exerciseLog.intensity != null) ...[
                      Text(
                        ' • ${exerciseLog.intensity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${exerciseLog.caloriesBurned}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              Text(
                'kcal',
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondaryColor,
                ),
              ),
            ],
          ),
          // Removed delete button - users can manage exercises from detail screens
        ],
      ),
    );
  }
}
