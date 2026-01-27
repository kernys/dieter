import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/models/badge_model.dart';
import '../providers/badges_provider.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final badgesAsync = ref.watch(badgesProvider);
    final selectedCategory = ref.watch(badgeCategoryFilterProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.badges,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: badgesAsync.when(
        data: (data) => Column(
          children: [
            // Stats header
            _StatsHeader(stats: data.stats),
            
            // Category filter
            _CategoryFilter(
              categories: _getCategories(data.badges),
              selected: selectedCategory,
              onSelected: (category) {
                ref.read(badgeCategoryFilterProvider.notifier).state = category;
              },
            ),
            
            // Badges grid
            Expanded(
              child: _BadgesGrid(
                badges: selectedCategory == null 
                    ? data.badges 
                    : data.badges.where((b) => b.category == selectedCategory).toList(),
                onBadgeTap: (badge) => _showBadgeDetail(context, ref, badge),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              Text('Error loading badges: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(badgesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getCategories(List<BadgeModel> badges) {
    return badges.map((b) => b.category).toSet().toList()..sort();
  }

  void _showBadgeDetail(BuildContext context, WidgetRef ref, BadgeModel badge) {
    // Mark as seen if new
    if (badge.isNew && badge.earned) {
      ref.read(markBadgeSeenProvider)(badge.id);
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _BadgeDetailSheet(badge: badge),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final BadgeStats stats;

  const _StatsHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentage = stats.total > 0 
        ? (stats.earned / stats.total * 100).round() 
        : 0;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Trophy icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stats.earned} / ${stats.total}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.badgesEarned,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final Function(String?) onSelected;

  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  String _getCategoryLabel(String category, AppLocalizations l10n) {
    switch (category) {
      case 'streak': return l10n.streak;
      case 'food': return l10n.food;
      case 'exercise': return l10n.exercise;
      case 'weight': return l10n.weight;
      case 'social': return l10n.social;
      default: return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'streak': return Icons.local_fire_department;
      case 'food': return Icons.restaurant;
      case 'exercise': return Icons.fitness_center;
      case 'weight': return Icons.monitor_weight;
      case 'social': return Icons.group;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // All filter
          _FilterChip(
            label: l10n.all,
            icon: Icons.grid_view,
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          // Category filters
          ...categories.map((category) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              label: _getCategoryLabel(category, l10n),
              icon: _getCategoryIcon(category),
              isSelected: selected == category,
              onTap: () => onSelected(category),
            ),
          )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  final List<BadgeModel> badges;
  final Function(BadgeModel) onBadgeTap;

  const _BadgesGrid({
    required this.badges,
    required this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        return _BadgeItem(
          badge: badges[index],
          onTap: () => onBadgeTap(badges[index]),
        );
      },
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const _BadgeItem({
    required this.badge,
    required this.onTap,
  });

  IconData _getCategoryIcon() {
    switch (badge.category) {
      case 'streak': return Icons.local_fire_department;
      case 'food': return Icons.restaurant;
      case 'exercise': return Icons.fitness_center;
      case 'weight': return Icons.monitor_weight;
      case 'social': return Icons.group;
      default: return Icons.star;
    }
  }

  Color _getCategoryColor() {
    switch (badge.category) {
      case 'streak': return Colors.orange;
      case 'food': return Colors.green;
      case 'exercise': return Colors.blue;
      case 'weight': return Colors.purple;
      case 'social': return Colors.pink;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = badge.earned ? _getCategoryColor() : Colors.grey;
    
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            children: [
              // Badge icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: badge.earned 
                      ? color.withOpacity(0.2)
                      : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badge.earned ? color : AppColors.border,
                    width: 2,
                  ),
                ),
                child: badge.iconUrl != null
                    ? ClipOval(
                        child: Image.network(
                          badge.iconUrl!,
                          fit: BoxFit.cover,
                          color: badge.earned ? null : Colors.grey,
                          colorBlendMode: badge.earned ? null : BlendMode.saturation,
                        ),
                      )
                    : Icon(
                        _getCategoryIcon(),
                        size: 32,
                        color: badge.earned ? color : AppColors.textTertiary,
                      ),
              ),
              const SizedBox(height: 8),
              // Badge name
              Text(
                badge.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: badge.earned ? AppColors.textPrimary : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Progress indicator
              if (!badge.earned && badge.progress > 0) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: 50,
                  child: LinearProgressIndicator(
                    value: badge.progress / 100,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.5)),
                  ),
                ),
              ],
            ],
          ),
          // New badge indicator
          if (badge.isNew && badge.earned)
            Positioned(
              right: 15,
              top: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BadgeDetailSheet extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeDetailSheet({required this.badge});

  IconData _getCategoryIcon() {
    switch (badge.category) {
      case 'streak': return Icons.local_fire_department;
      case 'food': return Icons.restaurant;
      case 'exercise': return Icons.fitness_center;
      case 'weight': return Icons.monitor_weight;
      case 'social': return Icons.group;
      default: return Icons.star;
    }
  }

  Color _getCategoryColor() {
    switch (badge.category) {
      case 'streak': return Colors.orange;
      case 'food': return Colors.green;
      case 'exercise': return Colors.blue;
      case 'weight': return Colors.purple;
      case 'social': return Colors.pink;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = badge.earned ? _getCategoryColor() : Colors.grey;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Badge icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: badge.earned 
                  ? color.withOpacity(0.2)
                  : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: badge.earned ? color : AppColors.border,
                width: 3,
              ),
            ),
            child: badge.iconUrl != null
                ? ClipOval(
                    child: Image.network(
                      badge.iconUrl!,
                      fit: BoxFit.cover,
                      color: badge.earned ? null : Colors.grey,
                      colorBlendMode: badge.earned ? null : BlendMode.saturation,
                    ),
                  )
                : Icon(
                    _getCategoryIcon(),
                    size: 48,
                    color: badge.earned ? color : AppColors.textTertiary,
                  ),
          ),
          const SizedBox(height: 16),
          // Badge name
          Text(
            badge.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Badge description
          Text(
            badge.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Status
          if (badge.earned) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    badge.earnedAt != null
                        ? l10n.earnedOn(_formatDate(badge.earnedAt!))
                        : l10n.badgeEarned,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Progress
            Column(
              children: [
                LinearProgressIndicator(
                  value: badge.progress / 100,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  '${badge.progress}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
