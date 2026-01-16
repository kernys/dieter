import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/food_entry_model.dart';

class FoodEntryCard extends StatelessWidget {
  final FoodEntryModel entry;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const FoodEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: entry.imageUrl != null && entry.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: entry.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.fastfood,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.fastfood,
                        color: AppColors.textTertiary,
                        size: 32,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Food Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.calories} Calories',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _MacroChip(
                        icon: Icons.egg_outlined,
                        value: '${entry.protein.toInt()}g',
                        color: AppColors.protein,
                      ),
                      const SizedBox(width: 8),
                      _MacroChip(
                        icon: Icons.grass,
                        value: '${entry.carbs.toInt()}g',
                        color: AppColors.carbs,
                      ),
                      const SizedBox(width: 8),
                      _MacroChip(
                        icon: Icons.water_drop_outlined,
                        value: '${entry.fat.toInt()}g',
                        color: AppColors.fat,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Time and Menu
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('h:mma').format(entry.loggedAt.toLocal()).toLowerCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                _buildMoreMenu(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        size: 20,
        color: AppColors.textTertiary,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        switch (value) {
          case 'share':
            _shareEntry(context);
            break;
          case 'delete':
            _confirmDelete(context, l10n);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              const Icon(Icons.share_outlined, size: 20),
              const SizedBox(width: 12),
              Text(l10n.share),
            ],
          ),
        ),
        if (onDelete != null)
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                const SizedBox(width: 12),
                Text(l10n.delete, style: const TextStyle(color: AppColors.error)),
              ],
            ),
          ),
      ],
    );
  }

  void _shareEntry(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final shareText = '''
${entry.name}

🔥 ${entry.calories} ${l10n.cal}
🥚 ${l10n.protein}: ${entry.protein.toStringAsFixed(1)}g
🌾 ${l10n.carbohydrates}: ${entry.carbs.toStringAsFixed(1)}g
💧 ${l10n.fat}: ${entry.fat.toStringAsFixed(1)}g

${l10n.sharedFromDieterAI}
''';

    Share.share(shareText.trim());
    onShare?.call();
  }

  void _confirmDelete(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
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
}

class _MacroChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MacroChip({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
