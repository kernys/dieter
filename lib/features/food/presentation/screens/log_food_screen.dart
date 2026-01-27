import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../providers/saved_foods_provider.dart';
import 'manual_food_entry_screen.dart';
import 'voice_food_entry_screen.dart';

class LogFoodScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const LogFoodScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends ConsumerState<LogFoodScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FoodSearchItem> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  final List<_FoodSuggestion> _defaultSuggestions = [
    _FoodSuggestion(name: 'Peanut Butter', calories: 94, unit: 'tbsp', protein: 4.0, carbs: 3.0, fats: 8.0, fiber: 1.0, sugar: 1.0, sodium: 73),
    _FoodSuggestion(name: 'Avocado', calories: 160, unit: 'half', protein: 2.0, carbs: 9.0, fats: 15.0, fiber: 7.0, sugar: 0.7, sodium: 7),
    _FoodSuggestion(name: 'Chicken Breast', calories: 165, unit: '100g', protein: 31.0, carbs: 0.0, fats: 3.6, fiber: 0, sugar: 0, sodium: 74),
    _FoodSuggestion(name: 'Brown Rice', calories: 216, unit: 'cup', protein: 5.0, carbs: 45.0, fats: 1.8, fiber: 3.5, sugar: 0.7, sodium: 10),
    _FoodSuggestion(name: 'Greek Yogurt', calories: 100, unit: 'container', protein: 17.0, carbs: 6.0, fats: 0.7, fiber: 0, sugar: 4.0, sodium: 56),
    _FoodSuggestion(name: 'Banana', calories: 105, unit: 'medium', protein: 1.3, carbs: 27.0, fats: 0.4, fiber: 3.1, sugar: 14.0, sodium: 1),
    _FoodSuggestion(name: 'Eggs', calories: 78, unit: 'large', protein: 6.0, carbs: 0.6, fats: 5.0, fiber: 0, sugar: 0.6, sodium: 62),
    _FoodSuggestion(name: 'Salmon', calories: 208, unit: '100g', protein: 20.0, carbs: 0.0, fats: 13.0, fiber: 0, sugar: 0, sodium: 59),
    _FoodSuggestion(name: 'Oatmeal', calories: 158, unit: 'cup', protein: 6.0, carbs: 27.0, fats: 3.0, fiber: 4.0, sugar: 1.0, sodium: 115),
    _FoodSuggestion(name: 'Sweet Potato', calories: 103, unit: 'medium', protein: 2.3, carbs: 24.0, fats: 0.1, fiber: 3.8, sugar: 7.0, sodium: 41),
    _FoodSuggestion(name: 'Almonds', calories: 164, unit: '28g', protein: 6.0, carbs: 6.0, fats: 14.0, fiber: 3.5, sugar: 1.2, sodium: 0),
    _FoodSuggestion(name: 'Broccoli', calories: 55, unit: 'cup', protein: 3.7, carbs: 11.0, fats: 0.6, fiber: 5.1, sugar: 2.2, sodium: 64),
    _FoodSuggestion(name: 'Quinoa', calories: 222, unit: 'cup', protein: 8.0, carbs: 39.0, fats: 3.5, fiber: 5.0, sugar: 1.6, sodium: 13),
    _FoodSuggestion(name: 'Tofu', calories: 144, unit: '100g', protein: 17.0, carbs: 3.0, fats: 8.0, fiber: 2.3, sugar: 0, sodium: 14),
    _FoodSuggestion(name: 'Spinach', calories: 23, unit: 'cup', protein: 2.9, carbs: 3.6, fats: 0.4, fiber: 2.2, sugar: 0.4, sodium: 79),
    _FoodSuggestion(name: 'Cottage Cheese', calories: 163, unit: 'cup', protein: 28.0, carbs: 6.0, fats: 2.3, fiber: 0, sugar: 6.0, sodium: 918),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex.clamp(0, 1));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);

    _debounceTimer?.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.searchFood(query, lang: locale);

      if (mounted) {
        setState(() {
          _searchResults = response.foods;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        title: Text(
          l10n.logFood,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: l10n.all),
                Tab(text: l10n.savedFoods),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllTab(l10n),
                _buildSavedFoodsTab(),
              ],
            ),
          ),

          // Fixed bottom action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.list_alt,
                      label: l10n.manualAdd,
                      onTap: () => _showManualAddSheet(l10n),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.mic,
                      label: l10n.voiceLog,
                      onTap: () => _showVoiceLog(l10n),
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

  Widget _buildAllTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.describeWhatYouAte,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _performSearch(value);
                      }
                    },
                  ),
                ),
                if (_isSearching)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _searchResults = [];
                      });
                    },
                    child: Icon(Icons.close, color: AppColors.textTertiary, size: 20),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Search results or suggestions
          if (_searchQuery.isNotEmpty && _searchResults.isNotEmpty) ...[
            Text(
              l10n.searchResults,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._searchResults.map((food) => _buildSearchResultItem(food, l10n)),
          ] else if (_searchQuery.isNotEmpty && !_isSearching && _searchResults.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: AppColors.textTertiary),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noSearchResults,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Default suggestions
            Text(
              l10n.suggestions,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._defaultSuggestions.map((suggestion) => _buildSuggestionItem(suggestion, l10n)),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(FoodSearchItem food, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${food.calories} ${l10n.cal}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '· ${food.servingSize}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'P: ${food.protein.toStringAsFixed(0)}g · C: ${food.carbs.toStringAsFixed(0)}g · F: ${food.fat.toStringAsFixed(0)}g',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _addSearchResult(food, l10n),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addSearchResult(FoodSearchItem food, AppLocalizations l10n) async {
    final authState = ref.read(authStateProvider);
    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
      );
      return;
    }

    try {
      await ref.read(addFoodEntryProvider(AddFoodEntryParams(
        name: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
        imageUrl: food.imageUrl,
      )).future);

      if (mounted) {
        // Refresh progress data
        ref.invalidate(weeklyEnergyDataProvider);
        ref.invalidate(streakDataProvider);
        ref.invalidate(dailyAverageCaloriesProvider);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addedFood(food.name)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToLogFood(e.toString()))),
        );
      }
    }
  }

  Widget _buildSuggestionItem(_FoodSuggestion suggestion, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${suggestion.calories} ${l10n.cal}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '· ${suggestion.unit}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _addFood(suggestion, l10n),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedFoodsTab() {
    final l10n = AppLocalizations.of(context)!;
    final savedFoods = ref.watch(savedFoodsProvider);

    if (savedFoods.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border,
                  size: 40,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.noSavedFoods,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tapToSaveHere,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savedFoods.length,
      itemBuilder: (context, index) {
        final food = savedFoods[index];
        return _buildSavedFoodItem(food, l10n);
      },
    );
  }

  Widget _buildSavedFoodItem(SavedFood food, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (food.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food.imageUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, color: AppColors.textTertiary),
                ),
              ),
            )
          else
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, color: AppColors.textTertiary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${food.calories} cal · P: ${food.protein.toStringAsFixed(0)}g · C: ${food.carbs.toStringAsFixed(0)}g · F: ${food.fat.toStringAsFixed(0)}g',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _logSavedFood(food, l10n),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    l10n.logThisFood,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ref.read(savedFoodsProvider.notifier).removeFood(food.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.removedFromSaved)),
                  );
                },
                child: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logSavedFood(SavedFood food, AppLocalizations l10n) async {
    final authState = ref.read(authStateProvider);
    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
      );
      return;
    }

    try {
      await ref.read(addFoodEntryProvider(AddFoodEntryParams(
        name: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
        imageUrl: food.imageUrl,
      )).future);

      if (mounted) {
        // Refresh progress data
        ref.invalidate(weeklyEnergyDataProvider);
        ref.invalidate(streakDataProvider);
        ref.invalidate(dailyAverageCaloriesProvider);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.foodEntrySaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToLogFood(e.toString()))),
        );
      }
    }
  }

  Future<void> _addFood(_FoodSuggestion suggestion, AppLocalizations l10n) async {
    final authState = ref.read(authStateProvider);
    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
      );
      return;
    }

    try {
      await ref.read(addFoodEntryProvider(AddFoodEntryParams(
        name: suggestion.name,
        calories: suggestion.calories,
        protein: 0,
        carbs: 0,
        fat: 0,
      )).future);

      if (mounted) {
        // Refresh progress data
        ref.invalidate(weeklyEnergyDataProvider);
        ref.invalidate(streakDataProvider);
        ref.invalidate(dailyAverageCaloriesProvider);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addedFood(suggestion.name)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToLogFood(e.toString()))),
        );
      }
    }
  }

  void _showManualAddSheet(AppLocalizations l10n) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ManualFoodEntryScreen(),
      ),
    );
  }

  void _showVoiceLog(AppLocalizations l10n) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VoiceFoodEntryScreen(),
      ),
    );
  }
}

class _FoodSuggestion {
  final String name;
  final int calories;
  final String unit;
  final double protein;
  final double carbs;
  final double fats;
  final double? fiber;
  final double? sugar;
  final double? sodium; // in mg

  _FoodSuggestion({
    required this.name,
    required this.calories,
    required this.unit,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.fiber,
    this.sugar,
    this.sodium,
  });
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualAddSheet extends StatefulWidget {
  final AppLocalizations l10n;

  const _ManualAddSheet({required this.l10n});

  @override
  State<_ManualAddSheet> createState() => _ManualAddSheetState();
}

class _ManualAddSheetState extends State<_ManualAddSheet> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

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
    final l10n = widget.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addFoodManually,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, l10n.foodName, ''),
            const SizedBox(height: 12),
            _buildTextField(_caloriesController, l10n.calories, l10n.cal),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_proteinController, l10n.protein, 'g'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(_carbsController, l10n.carbs, 'g'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(_fatController, l10n.fat, 'g'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(l10n.addFood),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String suffix) {
    return TextField(
      controller: controller,
      keyboardType: label == 'Food Name'
          ? TextInputType.text
          : const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix.isNotEmpty ? suffix : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _saveFood() {
    // TODO: Save food entry via API
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.l10n.addedFood(_nameController.text)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
