import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
    final user = ref.watch(currentUserProvider);
    final settings = ref.watch(settingsProvider);
    final isImperial = settings.unitSystem == UnitSystem.imperial;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
        title: const Text(
          'Personal Details',
          style: TextStyle(
            color: AppColors.textPrimary,
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
            // Goal Weight Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Goal Weight',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatWeight(user?.goalWeight, isImperial),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _editGoalWeight(user?.goalWeight),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Change Goal'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Current weight',
                    value: _formatWeight(user?.currentWeight, isImperial),
                    onEdit: () => _editCurrentWeight(user?.currentWeight),
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Height',
                    value: _formatHeight(
                      user?.heightFeet,
                      user?.heightInches,
                      user?.heightCm,
                      isImperial,
                    ),
                    onEdit: () => _editHeight(
                      user?.heightFeet,
                      user?.heightInches,
                      user?.heightCm,
                    ),
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Date of birth',
                    value: user?.birthDate != null
                        ? DateFormat('yyyy. M. d.').format(user!.birthDate!)
                        : 'Not set',
                    onEdit: () => _editBirthDate(user?.birthDate),
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Gender',
                    value: user?.gender ?? 'Not set',
                    onEdit: () => _editGender(user?.gender),
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Daily step goal',
                    value: '${user?.dailyStepGoal ?? 10000} steps',
                    onEdit: () => _editStepGoal(user?.dailyStepGoal ?? 10000),
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

  String _formatWeight(double? weight, bool isImperial) {
    if (weight == null) return 'Not set';
    if (isImperial) {
      return '${weight.toStringAsFixed(1)} lbs';
    } else {
      final kg = weight * 0.453592;
      return '${kg.toStringAsFixed(1)} kg';
    }
  }

  String _formatHeight(
      double? feet, double? inches, double? cm, bool isImperial) {
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
    return 'Not set';
  }

  void _editGoalWeight(double? currentValue) {
    _showEditDialog(
      title: 'Goal Weight',
      currentValue: currentValue?.toString() ?? '',
      suffix: 'lbs',
      onSave: (value) {
        final weight = double.tryParse(value);
        if (weight != null) {
          ref.read(authStateProvider.notifier).updateUser({
            'goal_weight': weight,
          });
        }
      },
    );
  }

  void _editCurrentWeight(double? currentValue) {
    _showEditDialog(
      title: 'Current Weight',
      currentValue: currentValue?.toString() ?? '',
      suffix: 'lbs',
      onSave: (value) {
        final weight = double.tryParse(value);
        if (weight != null) {
          ref.read(authStateProvider.notifier).updateUser({
            'current_weight': weight,
          });
        }
      },
    );
  }

  void _editHeight(double? feet, double? inches, double? cm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _HeightEditSheet(
        initialFeet: feet?.toInt() ?? 5,
        initialInches: inches?.toInt() ?? 6,
        onSave: (ft, inch) {
          ref.read(authStateProvider.notifier).updateUser({
            'height_feet': ft.toDouble(),
            'height_inches': inch.toDouble(),
          });
          Navigator.pop(context);
        },
      ),
    );
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
        'birth_date': date.toIso8601String(),
      });
    }
  }

  void _editGender(String? currentGender) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Gender',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _GenderOption(
              label: 'Male',
              isSelected: currentGender == 'Male',
              onTap: () {
                ref.read(authStateProvider.notifier).updateUser({
                  'gender': 'Male',
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _GenderOption(
              label: 'Female',
              isSelected: currentGender == 'Female',
              onTap: () {
                ref.read(authStateProvider.notifier).updateUser({
                  'gender': 'Female',
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _GenderOption(
              label: 'Other',
              isSelected: currentGender == 'Other',
              onTap: () {
                ref.read(authStateProvider.notifier).updateUser({
                  'gender': 'Other',
                });
                Navigator.pop(context);
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
            'daily_step_goal': steps,
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit $title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                suffixText: suffix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
                  Navigator.pop(context);
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

  const _HeightEditSheet({
    required this.initialFeet,
    required this.initialInches,
    required this.onSave,
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
