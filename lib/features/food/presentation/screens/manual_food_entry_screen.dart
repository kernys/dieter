import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';

class ManualFoodEntryScreen extends ConsumerStatefulWidget {
  const ManualFoodEntryScreen({super.key});

  @override
  ConsumerState<ManualFoodEntryScreen> createState() => _ManualFoodEntryScreenState();
}

class _ManualFoodEntryScreenState extends ConsumerState<ManualFoodEntryScreen> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController(text: '0');
  final _proteinController = TextEditingController(text: '0');
  final _carbsController = TextEditingController(text: '0');
  final _fatController = TextEditingController(text: '0');
  int _servings = 1;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _ingredients = [];

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.manualAdd,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _formatTime(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: context.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Food Name
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showNameEditDialog(l10n),
                    child: Text(
                      _nameController.text.isEmpty ? l10n.tapToName : _nameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _nameController.text.isEmpty
                            ? context.textSecondaryColor
                            : context.textPrimaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Servings
                GestureDetector(
                  onTap: () => _showServingsDialog(l10n),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$_servings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: context.textSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Calories Card
            GestureDetector(
              onTap: () => _showNutrientEditDialog(l10n, 'calories'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.calories,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textSecondaryColor,
                          ),
                        ),
                        Text(
                          _caloriesController.text,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Macros Row
            Row(
              children: [
                Expanded(
                  child: _buildMacroCard(
                    l10n,
                    l10n.protein,
                    _proteinController.text,
                    'g',
                    Colors.red,
                    Icons.egg_alt,
                    'protein',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroCard(
                    l10n,
                    l10n.carbs,
                    _carbsController.text,
                    'g',
                    Colors.amber,
                    Icons.grass,
                    'carbs',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMacroCard(
                    l10n,
                    l10n.fat,
                    _fatController.text,
                    'g',
                    Colors.blue,
                    Icons.water_drop,
                    'fat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ingredients Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.ingredients,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddIngredientDialog(l10n),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_ingredients.isEmpty)
              Center(
                child: Text(
                  l10n.noIngredientsDetected,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textSecondaryColor,
                  ),
                ),
              )
            else
              ..._ingredients.asMap().entries.map((entry) {
                final index = entry.key;
                final ingredient = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ingredient['name'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimaryColor,
                              ),
                            ),
                            if (ingredient['calories'] != null && ingredient['calories'] > 0)
                              Text(
                                '${ingredient['calories']} cal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.textSecondaryColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => _ingredients.removeAt(index));
                        },
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _logFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.log,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroCard(
    AppLocalizations l10n,
    String label,
    String value,
    String unit,
    Color color,
    IconData icon,
    String type,
  ) {
    return GestureDetector(
      onTap: () => _showNutrientEditDialog(l10n, type),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: context.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$value$unit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  void _showAddIngredientDialog(AppLocalizations l10n) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addIngredient),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.name,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.calories,
                suffixText: 'cal',
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _ingredients.add({
                    'name': nameController.text,
                    'calories': int.tryParse(caloriesController.text) ?? 0,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showNameEditDialog(AppLocalizations l10n) {
    final controller = TextEditingController(text: _nameController.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.foodName),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.tapToName,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() => _nameController.text = controller.text);
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showServingsDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.servings),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (_servings > 1) {
                  setState(() => _servings--);
                  Navigator.pop(ctx);
                  _showServingsDialog(l10n);
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '$_servings',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() => _servings++);
                Navigator.pop(ctx);
                _showServingsDialog(l10n);
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  void _showNutrientEditDialog(AppLocalizations l10n, String type) {
    TextEditingController controller;
    String title;

    switch (type) {
      case 'calories':
        controller = TextEditingController(text: _caloriesController.text);
        title = l10n.calories;
        break;
      case 'protein':
        controller = TextEditingController(text: _proteinController.text);
        title = l10n.protein;
        break;
      case 'carbs':
        controller = TextEditingController(text: _carbsController.text);
        title = l10n.carbs;
        break;
      case 'fat':
        controller = TextEditingController(text: _fatController.text);
        title = l10n.fat;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            suffixText: type == 'calories' ? 'cal' : 'g',
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                switch (type) {
                  case 'calories':
                    _caloriesController.text = controller.text;
                    break;
                  case 'protein':
                    _proteinController.text = controller.text;
                    break;
                  case 'carbs':
                    _carbsController.text = controller.text;
                    break;
                  case 'fat':
                    _fatController.text = controller.text;
                    break;
                }
              });
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _logFood() async {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.read(authStateProvider);

    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
      );
      return;
    }

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterFoodName)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.createFoodEntry(
        userId: authState.userId!,
        name: name,
        calories: (int.tryParse(_caloriesController.text) ?? 0) * _servings,
        protein: (double.tryParse(_proteinController.text) ?? 0) * _servings,
        carbs: (double.tryParse(_carbsController.text) ?? 0) * _servings,
        fat: (double.tryParse(_fatController.text) ?? 0) * _servings,
        servings: _servings,
      );

      // Refresh food entries
      ref.invalidate(dailySummaryProvider(DateTime.now()));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 8),
                Text(l10n.foodLogged),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoggingFood)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
