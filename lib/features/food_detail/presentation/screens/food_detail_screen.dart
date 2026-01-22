import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_colors.dart';
import '../../../../services/api_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/models/food_entry_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../food/presentation/providers/saved_foods_provider.dart';

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
  String? _imageUrl;
  FoodAnalysisResult? _result;
  FoodEntryModel? _existingEntry;
  List<IngredientAnalysis> _ingredients = [];
  bool _isLoading = false;
  bool _isViewMode = false;
  DateTime? _loggedAt;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Additional nutrition data
  double _fiber = 0;
  double _sugar = 0;
  double _sodium = 0;
  int _healthScore = 5;

  @override
  void initState() {
    super.initState();

    // Check if viewing existing entry
    if (widget.analysisResult != null) {
      if (widget.analysisResult!.containsKey('entry')) {
        // Viewing existing entry
        _existingEntry = widget.analysisResult!['entry'] as FoodEntryModel?;
        _isViewMode = true;
        if (_existingEntry != null) {
          _imageUrl = _existingEntry!.imageUrl;
          _loggedAt = _existingEntry!.loggedAt;
          _servings = _existingEntry!.servings;
          _nameController = TextEditingController(text: _existingEntry!.name);
          _caloriesController = TextEditingController(text: (_existingEntry!.calories ~/ _existingEntry!.servings).toString());
          _proteinController = TextEditingController(text: (_existingEntry!.protein / _existingEntry!.servings).toStringAsFixed(1));
          _carbsController = TextEditingController(text: (_existingEntry!.carbs / _existingEntry!.servings).toStringAsFixed(1));
          _fatController = TextEditingController(text: (_existingEntry!.fat / _existingEntry!.servings).toStringAsFixed(1));
          _ingredients = _existingEntry!.ingredients.map((i) => IngredientAnalysis(
            name: i.name,
            amount: i.amount,
            calories: i.calories,
            protein: i.protein,
            carbs: i.carbs,
            fat: i.fat,
          )).toList();
          return;
        }
      } else {
        // Creating new entry from analysis
        _result = widget.analysisResult!['analysisResult'] as FoodAnalysisResult?;
        _imageBytes = widget.analysisResult!['imageBytes'] as Uint8List?;
      }
    }

    _nameController = TextEditingController(text: _result?.name ?? '');
    _caloriesController = TextEditingController(text: _result?.calories.toString() ?? '0');
    _proteinController = TextEditingController(text: _result?.protein.toString() ?? '0');
    _carbsController = TextEditingController(text: _result?.carbs.toString() ?? '0');
    _fatController = TextEditingController(text: _result?.fat.toString() ?? '0');
    _ingredients = _result?.ingredients ?? [];
    _fiber = _result?.fiber ?? 0;
    _sugar = _result?.sugar ?? 0;
    _sodium = _result?.sodium ?? 0;
    _healthScore = _result?.healthScore ?? 5;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _pageController.dispose();
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
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          // Image Header
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[200],
                child: _buildImageWidget(),
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
                          Consumer(
                            builder: (context, ref, _) {
                              final savedFoods = ref.watch(savedFoodsProvider);
                              final isSaved = savedFoods.any((f) =>
                                f.name.toLowerCase() == _nameController.text.toLowerCase());
                              return _HeaderButton(
                                icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                                onPressed: () => _toggleSaveFood(ref, l10n, isSaved),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _HeaderButton(
                            icon: Icons.ios_share,
                            onPressed: () => _shareEntry(l10n),
                          ),
                          const SizedBox(width: 8),
                          _HeaderButton(
                            icon: Icons.more_horiz,
                            onPressed: () => _showMoreOptions(l10n),
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
                          DateFormat('h:mm a').format((_loggedAt ?? DateTime.now()).toLocal()),
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

                    // Nutrition Pages (swipeable)
                    SizedBox(
                      height: 100,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() => _currentPage = page);
                        },
                        children: [
                          // Page 1: Protein, Carbs, Fat
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
                          // Page 2: Fiber, Sugar, Sodium, Health Score
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _MacroCard(
                                      label: l10n.fiber,
                                      value: '${(_fiber * _servings).toInt()}g',
                                      icon: Icons.spa_outlined,
                                      color: const Color(0xFF9C7CF4),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _MacroCard(
                                      label: l10n.sugar,
                                      value: '${(_sugar * _servings).toInt()}g',
                                      icon: Icons.cookie_outlined,
                                      color: const Color(0xFFFF6B9D),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _MacroCard(
                                      label: l10n.sodium,
                                      value: '${(_sodium * _servings).toInt()}mg',
                                      icon: Icons.grain,
                                      color: const Color(0xFFFFB347),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _HealthScoreCard(
                                score: _healthScore,
                                l10n: l10n,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PageIndicator(isActive: _currentPage == 0),
                        const SizedBox(width: 8),
                        _PageIndicator(isActive: _currentPage == 1),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                  if (!_isViewMode) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showFixResultsDialog(l10n),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.fixResults),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _isViewMode
                              ? () => context.pop()
                              : () => _saveFoodEntry(l10n),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isViewMode ? l10n.back : l10n.done),
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

  void _toggleSaveFood(WidgetRef ref, AppLocalizations l10n, bool isSaved) {
    final name = _nameController.text;
    if (name.isEmpty) return;

    if (isSaved) {
      // Find and remove
      final savedFoods = ref.read(savedFoodsProvider);
      final food = savedFoods.firstWhere(
        (f) => f.name.toLowerCase() == name.toLowerCase(),
      );
      ref.read(savedFoodsProvider.notifier).removeFood(food.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.removedFromSaved)),
      );
    } else {
      // Save the food
      final food = SavedFood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        protein: double.tryParse(_proteinController.text) ?? 0,
        carbs: double.tryParse(_carbsController.text) ?? 0,
        fat: double.tryParse(_fatController.text) ?? 0,
        imageUrl: _imageUrl,
        savedAt: DateTime.now(),
      );
      ref.read(savedFoodsProvider.notifier).addFood(food);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.savedToFavorites)),
      );
    }
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
        actionsAlignment: MainAxisAlignment.spaceBetween,
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
        actionsAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildImageWidget() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
      );
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(
            Icons.fastfood,
            size: 64,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return const Center(
        child: Icon(
          Icons.fastfood,
          size: 64,
          color: Colors.grey,
        ),
      );
    }
  }

  Future<void> _shareEntry(AppLocalizations l10n) async {
    final shareText = '''
${_nameController.text}

🔥 $_totalCalories ${l10n.cal}
🥚 ${l10n.protein}: ${_totalProtein.toStringAsFixed(1)}g
🌾 ${l10n.carbohydrates}: ${_totalCarbs.toStringAsFixed(1)}g
💧 ${l10n.fat}: ${_totalFat.toStringAsFixed(1)}g

${l10n.sharedFromDieterAI}
''';

    try {
      await Share.share(shareText.trim());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share failed: $e')),
        );
      }
    }
  }

  void _showMoreOptions(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
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
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              if (_imageBytes != null || (_imageUrl != null && _imageUrl!.isNotEmpty))
                ListTile(
                  leading: const Icon(Icons.save_alt, color: AppColors.primary),
                  title: Text(l10n.savePhotoToGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _savePhotoToGallery(l10n);
                  },
                ),
              if (_isViewMode)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text(l10n.deleteEntry, style: const TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(l10n);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePhotoToGallery(AppLocalizations l10n) async {
    try {
      Uint8List? imageData;

      if (_imageBytes != null) {
        imageData = _imageBytes;
      } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
        // Download image from URL
        final response = await http.get(Uri.parse(_imageUrl!));
        if (response.statusCode == 200) {
          imageData = response.bodyBytes;
        }
      }

      if (imageData != null) {
        final result = await ImageGallerySaverPlus.saveImage(
          imageData,
          quality: 100,
          name: 'diet_ai_${DateTime.now().millisecondsSinceEpoch}',
        );

        if (mounted) {
          if (result['isSuccess'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.photoSaved)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.failedToSavePhoto)),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToSavePhoto)),
        );
      }
    }
  }

  void _confirmDelete(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirm),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteEntry(l10n);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEntry(AppLocalizations l10n) async {
    if (_existingEntry == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(apiServiceProvider).deleteFoodEntry(_existingEntry!.id);
      ref.invalidate(dailySummaryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.entryDeleted)),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveFoodEntry(AppLocalizations l10n) async {
    setState(() => _isLoading = true);

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null || userId == 'guest-user') {
        throw Exception('Please login to save food entries');
      }

      final apiService = ref.read(apiServiceProvider);

      // Upload image if available
      String? imageUrl;
      if (_imageBytes != null) {
        try {
          imageUrl = await apiService.uploadImage(_imageBytes!);
        } catch (e) {
          // Continue without image if upload fails
          debugPrint('Image upload failed: $e');
        }
      }

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
        name: _nameController.text.isNotEmpty ? _nameController.text : l10n.unknownFood,
        calories: _totalCalories,
        protein: _totalProtein,
        carbs: _totalCarbs,
        fat: _totalFat,
        imageUrl: imageUrl,
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

class _HealthScoreCard extends StatelessWidget {
  final int score;
  final AppLocalizations l10n;

  const _HealthScoreCard({
    required this.score,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final clampedScore = score.clamp(1, 10);
    final scoreColor = clampedScore <= 3
        ? const Color(0xFFFF6B6B)
        : clampedScore <= 6
            ? const Color(0xFFFFB347)
            : const Color(0xFF4ECDC4);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: scoreColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.healthScore,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          // Progress bar
          Expanded(
            flex: 2,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.progressBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: clampedScore / 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: scoreColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$clampedScore/10',
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

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
