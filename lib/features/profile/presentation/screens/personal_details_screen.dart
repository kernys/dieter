import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../providers/settings_provider.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider);
    final isImperial = settings.unitSystem == UnitSystem.imperial;

    // Debug: check if user is loading
    if (user == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.cardColor,
              ),
              child: Icon(
                Icons.arrow_back,
                color: context.textPrimaryColor,
                size: 20,
              ),
            ),
          ),
          title: Text(
            l10n.personalDetails,
            style: TextStyle(
              color: context.textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.cardColor,
            ),
            child: Icon(
              Icons.arrow_back,
              color: context.textPrimaryColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          l10n.personalDetails,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Details Card
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: l10n.currentWeight,
                    value: _formatWeight(user.currentWeight, isImperial, l10n),
                    onEdit: () => _editCurrentWeight(user.currentWeight, l10n),
                  ),
                  Divider(height: 1, color: context.borderColor),
                  _DetailRow(
                    label: l10n.height,
                    value: _formatHeight(
                      user.heightFeet,
                      user.heightInches,
                      user.heightCm,
                      isImperial,
                      l10n,
                    ),
                    onEdit: () => _editHeight(
                      user.heightFeet,
                      user.heightInches,
                      user.heightCm,
                      l10n,
                    ),
                  ),
                  Divider(height: 1, color: context.borderColor),
                  _DetailRow(
                    label: l10n.dateOfBirth,
                    value: user.birthDate != null
                        ? DateFormat('yyyy. M. d.').format(user.birthDate!)
                        : l10n.notSet,
                    onEdit: () => _editBirthDate(user.birthDate),
                  ),
                  Divider(height: 1, color: context.borderColor),
                  _DetailRow(
                    label: l10n.gender,
                    value: user.gender ?? l10n.notSet,
                    onEdit: () => _editGender(user.gender, l10n),
                  ),
                  Divider(height: 1, color: context.borderColor),
                  _DetailRow(
                    label: l10n.dailyStepGoal,
                    value: '${user.dailyStepGoal} ${l10n.steps}',
                    onEdit: () => _editStepGoal(user.dailyStepGoal),
                    showBorder: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWeight(double? weight, bool isImperial, AppLocalizations l10n) {
    if (weight == null || weight == 0) return l10n.notSet;
    if (isImperial) {
      return '${weight.toStringAsFixed(1)} ${l10n.lbs}';
    } else {
      final kg = weight * 0.453592;
      return '${kg.toStringAsFixed(1)} ${l10n.kg}';
    }
  }

  String _formatHeight(
      double? feet, double? inches, double? cm, bool isImperial, AppLocalizations l10n) {
    if (isImperial) {
      if (feet != null && inches != null) {
        return '${feet.toInt()} ft ${inches.toInt()} in';
      }
      if (cm != null) {
        final totalInches = cm / 2.54;
        final ft = (totalInches / 12).floor();
        final inch = (totalInches % 12).round();
        return '$ft ft $inch in';
      }
    } else {
      if (cm != null) {
        return '${cm.toInt()} cm';
      }
      if (feet != null && inches != null) {
        final totalCm = (feet * 12 + inches) * 2.54;
        return '${totalCm.toInt()} cm';
      }
    }
    return l10n.notSet;
  }

  void _editGoalWeight(double? currentValue, AppLocalizations l10n) {
    final settings = ref.read(settingsProvider);
    final isImperial = settings.unitSystem == UnitSystem.imperial;

    // Convert stored lbs to display unit
    String displayValue = '';
    if (currentValue != null && currentValue > 0) {
      if (isImperial) {
        displayValue = currentValue.toStringAsFixed(1);
      } else {
        displayValue = (currentValue * 0.453592).toStringAsFixed(1);
      }
    }

    _showEditDialog(
      title: l10n.goalWeight,
      currentValue: displayValue,
      suffix: isImperial ? l10n.lbs : l10n.kg,
      onSave: (value) {
        final inputWeight = double.tryParse(value);
        if (inputWeight != null && inputWeight > 0) {
          // Convert to lbs if input is in kg (API stores in lbs)
          final weightInLbs = isImperial ? inputWeight : inputWeight / 0.453592;
          ref.read(authStateProvider.notifier).updateUser({
            'goalWeight': weightInLbs,
          });
        }
      },
    );
  }

  void _editCurrentWeight(double? currentValue, AppLocalizations l10n) {
    final settings = ref.read(settingsProvider);
    final isImperial = settings.unitSystem == UnitSystem.imperial;

    // Convert stored lbs to display unit
    String displayValue = '';
    if (currentValue != null && currentValue > 0) {
      if (isImperial) {
        displayValue = currentValue.toStringAsFixed(1);
      } else {
        displayValue = (currentValue * 0.453592).toStringAsFixed(1);
      }
    }

    _showEditDialog(
      title: l10n.currentWeight,
      currentValue: displayValue,
      suffix: isImperial ? l10n.lbs : l10n.kg,
      onSave: (value) async {
        final inputWeight = double.tryParse(value);
        if (inputWeight != null && inputWeight > 0) {
          // Convert to lbs if input is in kg (API stores in lbs)
          final weightInLbs = isImperial ? inputWeight : inputWeight / 0.453592;

          final authState = ref.read(authStateProvider);
          final userId = authState.userId;

          if (userId != null && !authState.isGuestMode) {
            // Create weight log entry (this also updates current_weight in user table)
            try {
              final apiService = ref.read(apiServiceProvider);
              await apiService.createWeightLog(
                weight: weightInLbs,
              );
              // Refresh user data and weight logs
              await ref.read(authStateProvider.notifier).refreshUser();
              ref.invalidate(weightLogsResponseProvider);
              ref.invalidate(weightChangeProvider);
            } catch (e) {
              // If weight log fails, still update user weight
              ref.read(authStateProvider.notifier).updateUser({
                'currentWeight': weightInLbs,
              });
            }
          } else {
            // Guest mode - just update user weight locally
            ref.read(authStateProvider.notifier).updateUser({
              'currentWeight': weightInLbs,
            });
          }
        }
      },
    );
  }

  void _editHeight(double? feet, double? inches, double? cm, AppLocalizations l10n) {
    final settings = ref.read(settingsProvider);
    final isImperial = settings.unitSystem == UnitSystem.imperial;

    if (isImperial) {
      // Use ft/in picker
      int initialFeet = 5;
      int initialInches = 6;

      if (feet != null && inches != null) {
        initialFeet = feet.toInt();
        initialInches = inches.toInt();
      } else if (cm != null) {
        final totalInches = cm / 2.54;
        initialFeet = (totalInches / 12).floor();
        initialInches = (totalInches % 12).round();
      }

      showModalBottomSheet(
        context: context,
        backgroundColor: context.cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetContext) => _HeightEditSheet(
          initialFeet: initialFeet,
          initialInches: initialInches,
          l10n: l10n,
          onSave: (ft, inch) {
            ref.read(authStateProvider.notifier).updateUser({
              'heightFeet': ft.toDouble(),
              'heightInches': inch.toDouble(),
              'heightCm': (ft * 12 + inch) * 2.54, // Also store in cm
            });
            Navigator.pop(sheetContext);
          },
        ),
      );
    } else {
      // Use cm input
      int initialCm = 170;

      if (cm != null) {
        initialCm = cm.toInt();
      } else if (feet != null && inches != null) {
        initialCm = ((feet * 12 + inches) * 2.54).round();
      }

      _showEditDialog(
        title: l10n.height,
        currentValue: initialCm.toString(),
        suffix: 'cm',
        onSave: (value) {
          final inputCm = double.tryParse(value);
          if (inputCm != null && inputCm > 0) {
            // Also calculate feet/inches for storage
            final totalInches = inputCm / 2.54;
            final ft = (totalInches / 12).floor();
            final inch = (totalInches % 12).round();
            ref.read(authStateProvider.notifier).updateUser({
              'heightCm': inputCm,
              'heightFeet': ft.toDouble(),
              'heightInches': inch.toDouble(),
            });
          }
        },
      );
    }
  }

  void _editBirthDate(DateTime? currentDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      ref.read(authStateProvider.notifier).updateUser({
        'birthDate': date.toIso8601String(),
      });
    }
  }

  void _editGender(String? currentGender, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gender,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: sheetContext.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _GenderOption(
              label: l10n.male,
              isSelected: currentGender == 'Male',
              onTap: () {
                ref.read(authStateProvider.notifier).updateUser({
                  'gender': 'Male',
                });
                Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 12),
            _GenderOption(
              label: l10n.female,
              isSelected: currentGender == 'Female',
              onTap: () {
                ref.read(authStateProvider.notifier).updateUser({
                  'gender': 'Female',
                });
                Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 12),
            _GenderOption(
              label: l10n.other,
              isSelected: currentGender == 'Other',
              onTap: () {
                ref.read(authStateProvider.notifier).updateUser({
                  'gender': 'Other',
                });
                Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _editStepGoal(int currentValue) {
    _showEditDialog(
      title: 'Daily Step Goal',
      currentValue: currentValue.toString(),
      suffix: 'steps',
      onSave: (value) {
        final steps = int.tryParse(value);
        if (steps != null) {
          ref.read(authStateProvider.notifier).updateUser({
            'dailyStepGoal': steps,
          });
        }
      },
    );
  }

  void _showEditDialog({
    required String title,
    required String currentValue,
    required String suffix,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: sheetContext.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(color: sheetContext.textPrimaryColor),
              decoration: InputDecoration(
                hintText: '0',
                suffixText: suffix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: sheetContext.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(sheetContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;
  final bool showBorder;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.onEdit,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onEdit,
            child: Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primary)
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _HeightEditSheet extends StatefulWidget {
  final int initialFeet;
  final int initialInches;
  final Function(int feet, int inches) onSave;
  final AppLocalizations l10n;

  const _HeightEditSheet({
    required this.initialFeet,
    required this.initialInches,
    required this.onSave,
    required this.l10n,
  });

  @override
  State<_HeightEditSheet> createState() => _HeightEditSheetState();
}

class _HeightEditSheetState extends State<_HeightEditSheet> {
  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late int _selectedFeet;
  late int _selectedInches;

  @override
  void initState() {
    super.initState();
    _selectedFeet = widget.initialFeet;
    _selectedInches = widget.initialInches;
    _feetController = FixedExtentScrollController(initialItem: _selectedFeet - 3);
    _inchesController = FixedExtentScrollController(initialItem: _selectedInches);
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Height',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: _feetController,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedFeet = index + 3);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 6,
                      builder: (context, index) {
                        final feet = index + 3;
                        final isSelected = feet == _selectedFeet;
                        return Center(
                          child: Text(
                            '$feet ft',
                            style: TextStyle(
                              fontSize: isSelected ? 18 : 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: _inchesController,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedInches = index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 12,
                      builder: (context, index) {
                        final isSelected = index == _selectedInches;
                        return Center(
                          child: Text(
                            '$index in',
                            style: TextStyle(
                              fontSize: isSelected ? 18 : 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => widget.onSave(_selectedFeet, _selectedInches),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
