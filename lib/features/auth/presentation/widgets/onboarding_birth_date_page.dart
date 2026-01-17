import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';

class OnboardingBirthDatePage extends ConsumerStatefulWidget {
  const OnboardingBirthDatePage({super.key});

  @override
  ConsumerState<OnboardingBirthDatePage> createState() =>
      _OnboardingBirthDatePageState();
}

class _OnboardingBirthDatePageState
    extends ConsumerState<OnboardingBirthDatePage> {
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int _selectedMonth = 1;
  int _selectedDay = 1;
  int _selectedYear = 2000;

  final int _startYear = 1920;
  final int _endYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    final onboardingState = ref.read(onboardingProvider);
    if (onboardingState.birthDate != null) {
      _selectedMonth = onboardingState.birthDate!.month;
      _selectedDay = onboardingState.birthDate!.day;
      _selectedYear = onboardingState.birthDate!.year;
    }

    _monthController =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _yearController =
        FixedExtentScrollController(initialItem: _selectedYear - _startYear);

    _updateBirthDate();
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _daysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  void _updateBirthDate() {
    final maxDays = _daysInMonth(_selectedMonth, _selectedYear);
    if (_selectedDay > maxDays) {
      _selectedDay = maxDays;
      _dayController.jumpToItem(_selectedDay - 1);
    }

    final birthDate =
        DateTime(_selectedYear, _selectedMonth, _selectedDay);
    ref.read(onboardingProvider.notifier).setBirthDate(birthDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'When were you born?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This will be used to calibrate your\ncustom plan.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const Spacer(),
          // Date picker wheels
          SizedBox(
            height: 250,
            child: Row(
              children: [
                // Month picker
                Expanded(
                  child: _buildWheelPicker(
                    controller: _monthController,
                    itemCount: 12,
                    itemBuilder: (index) => _months[index],
                    onChanged: (index) {
                      setState(() {
                        _selectedMonth = index + 1;
                        _updateBirthDate();
                      });
                    },
                  ),
                ),
                // Day picker
                Expanded(
                  child: _buildWheelPicker(
                    controller: _dayController,
                    itemCount: _daysInMonth(_selectedMonth, _selectedYear),
                    itemBuilder: (index) => '${index + 1}',
                    onChanged: (index) {
                      setState(() {
                        _selectedDay = index + 1;
                        _updateBirthDate();
                      });
                    },
                  ),
                ),
                // Year picker
                Expanded(
                  child: _buildWheelPicker(
                    controller: _yearController,
                    itemCount: _endYear - _startYear + 1,
                    itemBuilder: (index) => '${_startYear + index}',
                    onChanged: (index) {
                      setState(() {
                        _selectedYear = _startYear + index;
                        _updateBirthDate();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildWheelPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) itemBuilder,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 50,
      perspective: 0.005,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected = controller.hasClients &&
              controller.selectedItem == index;
          return Container(
            alignment: Alignment.center,
            decoration: isSelected
                ? BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Text(
              itemBuilder(index),
              style: TextStyle(
                fontSize: isSelected ? 18 : 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
          );
        },
      ),
    );
  }
}
