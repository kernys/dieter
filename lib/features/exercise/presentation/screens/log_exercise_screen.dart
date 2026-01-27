import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../providers/exercise_log_provider.dart';

class LogExerciseScreen extends ConsumerWidget {
  const LogExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          l10n.exercise,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.logExercise,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              _ExerciseOption(
                icon: Icons.directions_run,
                title: l10n.run,
                description: l10n.runDescription,
                onTap: () => _showRunInput(context, l10n, ref),
              ),
              const SizedBox(height: 12),
              _ExerciseOption(
                icon: Icons.fitness_center,
                title: l10n.weightLifting,
                description: l10n.weightLiftingDescription,
                onTap: () => _showWeightLiftingInput(context, l10n, ref),
              ),
              const SizedBox(height: 12),
              _ExerciseOption(
                icon: Icons.edit_note,
                title: l10n.describe,
                description: l10n.describeDescription,
                onTap: () => _showDescribeExercise(context, l10n, ref),
              ),
              const SizedBox(height: 12),
              _ExerciseOption(
                icon: Icons.local_fire_department,
                title: l10n.manual,
                description: l10n.manualDescription,
                onTap: () => _showManualCalories(context, l10n, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRunInput(BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    final durationController = TextEditingController();
    String selectedIntensity = 'Medium';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_run, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      l10n.run,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.intensity,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _IntensityChip(
                      label: l10n.low,
                      subtitle: '< 6 km/h',
                      isSelected: selectedIntensity == 'Low',
                      onTap: () => setState(() => selectedIntensity = 'Low'),
                    ),
                    const SizedBox(width: 8),
                    _IntensityChip(
                      label: l10n.medium,
                      subtitle: '6-10 km/h',
                      isSelected: selectedIntensity == 'Medium',
                      onTap: () => setState(() => selectedIntensity = 'Medium'),
                    ),
                    const SizedBox(width: 8),
                    _IntensityChip(
                      label: l10n.high,
                      subtitle: '> 10 km/h',
                      isSelected: selectedIntensity == 'High',
                      onTap: () => setState(() => selectedIntensity = 'High'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.durationMinutes,
                    hintText: l10n.enterDuration,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final duration = int.tryParse(durationController.text);
                      if (duration != null && duration > 0) {
                        // Calculate calories based on intensity
                        int caloriesPerMin;
                        switch (selectedIntensity) {
                          case 'Low':
                            caloriesPerMin = 8;
                            break;
                          case 'High':
                            caloriesPerMin = 15;
                            break;
                          default:
                            caloriesPerMin = 11;
                        }
                        final caloriesBurned = duration * caloriesPerMin;
                        final selectedDate = ref.read(selectedDateProvider);

                        ref.read(exerciseLogProvider.notifier).addLog(
                          ExerciseLog(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            type: l10n.run,
                            duration: duration,
                            caloriesBurned: caloriesBurned,
                            intensity: selectedIntensity,
                            loggedAt: selectedDate,
                          ),
                        );

                        // Refresh progress data
                        ref.invalidate(weeklyEnergyDataProvider);
                        ref.invalidate(streakDataProvider);

                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.runLogged(duration, selectedIntensity)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.logExercise,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWeightLiftingInput(BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    final durationController = TextEditingController();
    String selectedIntensity = 'Medium';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fitness_center, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      l10n.weightLifting,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.intensity,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _IntensityChip(
                      label: l10n.low,
                      subtitle: l10n.lightWeights,
                      isSelected: selectedIntensity == 'Low',
                      onTap: () => setState(() => selectedIntensity = 'Low'),
                    ),
                    const SizedBox(width: 8),
                    _IntensityChip(
                      label: l10n.medium,
                      subtitle: l10n.moderateWeights,
                      isSelected: selectedIntensity == 'Medium',
                      onTap: () => setState(() => selectedIntensity = 'Medium'),
                    ),
                    const SizedBox(width: 8),
                    _IntensityChip(
                      label: l10n.high,
                      subtitle: l10n.heavyWeights,
                      isSelected: selectedIntensity == 'High',
                      onTap: () => setState(() => selectedIntensity = 'High'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.durationMinutes,
                    hintText: l10n.enterDuration,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final duration = int.tryParse(durationController.text);
                      if (duration != null && duration > 0) {
                        // Calculate calories based on intensity
                        int caloriesPerMin;
                        switch (selectedIntensity) {
                          case 'Low':
                            caloriesPerMin = 4;
                            break;
                          case 'High':
                            caloriesPerMin = 8;
                            break;
                          default:
                            caloriesPerMin = 6;
                        }
                        final caloriesBurned = duration * caloriesPerMin;
                        final selectedDate = ref.read(selectedDateProvider);

                        ref.read(exerciseLogProvider.notifier).addLog(
                          ExerciseLog(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            type: l10n.weightLifting,
                            duration: duration,
                            caloriesBurned: caloriesBurned,
                            intensity: selectedIntensity,
                            loggedAt: selectedDate,
                          ),
                        );

                        // Refresh progress data
                        ref.invalidate(weeklyEnergyDataProvider);
                        ref.invalidate(streakDataProvider);

                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.weightLiftingLogged(duration, selectedIntensity)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.logExercise,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDescribeExercise(BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    final descriptionController = TextEditingController();
    bool isAnalyzing = false;
    ExerciseAnalysisResult? analysisResult;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.describeYourWorkout,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.describeHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),

                // Analysis result card
                if (analysisResult != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              analysisResult!.exerciseType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _AnalysisStatItem(
                              label: l10n.durationMinutes,
                              value: '${analysisResult!.duration}',
                            ),
                            _AnalysisStatItem(
                              label: l10n.caloriesBurned,
                              value: '${analysisResult!.caloriesBurned}',
                            ),
                            if (analysisResult!.intensity != null)
                              _AnalysisStatItem(
                                label: l10n.intensity,
                                value: analysisResult!.intensity!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isAnalyzing
                        ? null
                        : () async {
                            if (descriptionController.text.isEmpty) return;
                            final selectedDate = ref.read(selectedDateProvider);

                            // If already analyzed, log the exercise
                            if (analysisResult != null) {
                              ref.read(exerciseLogProvider.notifier).addLog(
                                ExerciseLog(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  type: analysisResult!.exerciseType,
                                  duration: analysisResult!.duration,
                                  caloriesBurned: analysisResult!.caloriesBurned,
                                  intensity: analysisResult!.intensity,
                                  description: descriptionController.text,
                                  loggedAt: selectedDate,
                                ),
                              );

                              // Refresh progress data
                              ref.invalidate(weeklyEnergyDataProvider);
                              ref.invalidate(streakDataProvider);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.exerciseLoggedSuccess)),
                              );
                              return;
                            }

                            // Analyze exercise with AI
                            setState(() => isAnalyzing = true);

                            try {
                              final apiService = ref.read(apiServiceProvider);
                              final locale = Localizations.localeOf(context).languageCode;
                              final result = await apiService.analyzeExercise(
                                descriptionController.text,
                                locale: locale,
                              );

                              setState(() {
                                analysisResult = result;
                                isAnalyzing = false;
                              });
                            } catch (e) {
                              setState(() => isAnalyzing = false);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.exerciseAnalysisFailed)),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isAnalyzing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.analyzingExercise,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            analysisResult != null ? l10n.logExercise : l10n.analyzeExercise,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showManualCalories(BuildContext context, AppLocalizations l10n, WidgetRef ref) {
    final caloriesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.caloriesBurned,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.calories,
                  hintText: l10n.enterCaloriesBurned,
                  suffixText: l10n.cal,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final calories = int.tryParse(caloriesController.text);
                    if (calories != null && calories > 0) {
                      final selectedDate = ref.read(selectedDateProvider);
                      ref.read(exerciseLogProvider.notifier).addLog(
                        ExerciseLog(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: l10n.exercise,
                          duration: 0,
                          caloriesBurned: calories,
                          loggedAt: selectedDate,
                        ),
                      );

                      // Refresh progress data
                      ref.invalidate(weeklyEnergyDataProvider);
                      ref.invalidate(streakDataProvider);

                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.caloriesBurnedLogged(calories))),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.logExercise,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ExerciseOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntensityChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _IntensityChip({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisStatItem extends StatelessWidget {
  final String label;
  final String value;

  const _AnalysisStatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
