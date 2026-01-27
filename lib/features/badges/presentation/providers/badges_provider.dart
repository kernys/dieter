import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/api_service.dart';
import '../../../../shared/models/badge_model.dart';

// All badges with user progress
final badgesProvider = FutureProvider<BadgesResponse>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getBadges();
});

// Check and award new badges
final checkBadgesProvider = FutureProvider<List<BadgeModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.checkBadges();
});

// Mark badge as seen
final markBadgeSeenProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String badgeId) async {
    await apiService.markBadgeSeen(badgeId);
    ref.invalidate(badgesProvider);
  };
});

// Badge category filter
final badgeCategoryFilterProvider = StateProvider<String?>((ref) => null);

// Filtered badges
final filteredBadgesProvider = Provider<List<BadgeModel>>((ref) {
  final badgesAsync = ref.watch(badgesProvider);
  final filter = ref.watch(badgeCategoryFilterProvider);
  
  return badgesAsync.maybeWhen(
    data: (data) {
      if (filter == null) return data.badges;
      return data.badges.where((b) => b.category == filter).toList();
    },
    orElse: () => [],
  );
});

// Badge stats
final badgeStatsProvider = Provider<BadgeStats?>((ref) {
  final badgesAsync = ref.watch(badgesProvider);
  
  return badgesAsync.maybeWhen(
    data: (data) => data.stats,
    orElse: () => null,
  );
});
