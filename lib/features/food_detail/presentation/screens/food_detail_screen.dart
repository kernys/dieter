import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/api_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String? foodId;
  final Map<String, dynamic>? analysisResult;

  const FoodDetailScreen({
    super.key,
    this.foodId,
    this.analysisResult,
  });

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  int _servings = 1;
  Uint8List? _imageBytes;
  FoodAnalysisResult? _result;
  List<IngredientAnalysis> _ingredients = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize with analysis result if available
    if (widget.analysisResult != null) {
      _result = widget.analysisResult!['analysisResult'] as FoodAnalysisResult?;
      _imageBytes = widget.analysisResult!['imageBytes'] as Uint8List?;
    }

    _nameController = TextEditingController(text: _result?.name ?? '');
    _caloriesController = TextEditingController(text: _result?.calories.toString() ?? '0');
    _proteinController = TextEditingController(text: _result?.protein.toString() ?? '0');
    _carbsController = TextEditingController(text: _result?.carbs.toString() ?? '0');
    _fatController = TextEditingController(text: _result?.fat.toString() ?? '0');
    _ingredients = _result?.ingredients ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  int get _totalCalories {
    final base = int.tryParse(_caloriesController.text) ?? 0;
    return base * _servings;
  }

  double get _totalProtein {
    final base = double.tryParse(_proteinController.text) ?? 0;
    return base * _servings;
  }

  double get _totalCarbs {
    final base = double.tryParse(_carbsController.text) ?? 0;
    return base * _servings;
  }

  double get _totalFat {
    final base = double.tryParse(_fatController.text) ?? 0;
    return base * _servings;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Image Header
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[200],
                child: _imageBytes != null
                    ? Image.memory(
                        _imageBytes!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
              ),
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
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
              ),
              // Top bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HeaderButton(
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        l10n.nutrition,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          _HeaderButton(
                            icon: Icons.ios_share,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                          _HeaderButton(
                            icon: Icons.more_horiz,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time and Name
                    Row(
                      children: [
                        const Icon(Icons.bookmark_border, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('h:mm a').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Name and servings
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text
                                : l10n.unknownFood,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: _servings > 1
                                    ? () => setState(() => _servings--)
                                    : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                              Text(
                                '$_servings',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () => setState(() => _servings++),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Calories Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_fire_department,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.calories,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '$_totalCalories',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Macro Row
                    Row(
                      children: [
                        Expanded(
                          child: _MacroCard(
                            label: l10n.protein,
                            value: '${_totalProtein.toInt()}g',
                            icon: Icons.egg_outlined,
                            color: AppColors.protein,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MacroCard(
                            label: l10n.carbs,
                            value: '${_totalCarbs.toInt()}g',
                            icon: Icons.grass,
                            color: AppColors.carbs,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MacroCard(
                            label: l10n.fats,
                            value: '${_totalFat.toInt()}g',
                            icon: Icons.water_drop_outlined,
                            color: AppColors.fat,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Ingredients
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.ingredients,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddIngredientDialog(l10n),
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(l10n.addMore),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (_ingredients.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            l10n.noIngredientsDetected,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...List.generate(_ingredients.length, (index) {
                        final ingredient = _ingredients[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ingredient.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (ingredient.amount != null)
                                      Text(
                                        '${ingredient.calories} cal • ${ingredient.amount}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      )
                                    else
                                      Text(
                                        '${ingredient.calories} cal',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _ingredients.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showFixResultsDialog(l10n),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.fixResults),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _saveFoodEntry(l10n),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.done),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddIngredientDialog(AppLocalizations l10n) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addIngredient),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: l10n.calories),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: l10n.amountOptional),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _ingredients.add(IngredientAnalysis(
                    name: nameController.text,
                    calories: int.tryParse(caloriesController.text) ?? 0,
                    amount: amountController.text.isNotEmpty
                        ? amountController.text
                        : null,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showFixResultsDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.fixResults),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.foodName),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(labelText: l10n.calories),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _proteinController,
                    decoration: InputDecoration(labelText: l10n.proteinG),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _carbsController,
                    decoration: InputDecoration(labelText: l10n.carbsG),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _fatController,
                    decoration: InputDecoration(labelText: l10n.fatG),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _saveFoodEntry(AppLocalizations l10n) async {
    setState(() => _isLoading = true);

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final apiService = ref.read(apiServiceProvider);

      // Convert ingredients to the expected format
      final ingredientsData = _ingredients.map((ingredient) => {
        'name': ingredient.name,
        'amount': ingredient.amount,
        'calories': ingredient.calories,
        'protein': ingredient.protein,
        'carbs': ingredient.carbs,
        'fat': ingredient.fat,
      }).toList();

      await apiService.createFoodEntry(
        userId: userId,
        name: _nameController.text.isNotEmpty ? _nameController.text : l10n.unknownFood,
        calories: _totalCalories,
        protein: _totalProtein,
        carbs: _totalCarbs,
        fat: _totalFat,
        ingredients: ingredientsData,
        servings: _servings,
      );

      // Invalidate the daily summary to refresh home screen
      ref.invalidate(dailySummaryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.foodEntrySaved)),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToSave(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
