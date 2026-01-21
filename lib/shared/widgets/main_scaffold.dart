import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import '../../features/progress/presentation/providers/progress_provider.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold>
    with SingleTickerProviderStateMixin {
  bool _isFabMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/progress')) return 1;
    if (location.startsWith('/party')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    final currentIndex = _calculateSelectedIndex(context);

    // Refresh data when switching tabs
    if (currentIndex != index) {
      switch (index) {
        case 0:
          // Home tab - refresh daily summary
          ref.invalidate(dailySummaryProvider);
          ref.invalidate(userGoalsProvider);
          ref.invalidate(streakProvider);
          break;
        case 1:
          // Progress tab - refresh weight logs and stats
          ref.invalidate(weightLogsProvider);
          ref.invalidate(streakDataProvider);
          ref.invalidate(dailyAverageCaloriesProvider);
          ref.invalidate(weeklyEnergyDataProvider);
          break;
        case 3:
          // Profile tab - refresh user goals
          ref.invalidate(userGoalsProvider);
          break;
      }
    }

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/progress');
        break;
      case 2:
        context.go('/party');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  void _toggleFabMenu() {
    setState(() {
      _isFabMenuOpen = !_isFabMenuOpen;
      if (_isFabMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeFabMenu() {
    if (_isFabMenuOpen) {
      setState(() {
        _isFabMenuOpen = false;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          // Overlay when menu is open
          if (_isFabMenuOpen)
            GestureDetector(
              onTap: _closeFabMenu,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Container(
                  color: Colors.black.withValues(alpha: 0.3 * _animation.value),
                ),
              ),
            ),
          // FAB Menu
          if (_isFabMenuOpen)
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              child: FadeTransition(
                opacity: _animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: _buildFabMenu(context),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.rotate(
          angle: _animation.value * 0.785, // 45 degrees
          child: FloatingActionButton(
            onPressed: _toggleFabMenu,
            backgroundColor: _isFabMenuOpen ? AppColors.textPrimary : AppColors.primary,
            child: Icon(
              _isFabMenuOpen ? Icons.close : Icons.add,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: l10n.home,
                    isSelected: selectedIndex == 0,
                    onTap: () => _onItemTapped(context, 0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    label: l10n.progress,
                    isSelected: selectedIndex == 1,
                    onTap: () => _onItemTapped(context, 1),
                  ),
                ),
                const SizedBox(width: 56), // Space for FAB
                Expanded(
                  child: _NavItem(
                    icon: Icons.celebration_outlined,
                    activeIcon: Icons.celebration,
                    label: 'Party',
                    isSelected: selectedIndex == 2,
                    onTap: () => _onItemTapped(context, 2),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: l10n.profile,
                    isSelected: selectedIndex == 3,
                    onTap: () => _onItemTapped(context, 3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFabMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _FabMenuItem(
                  icon: Icons.fitness_center,
                  label: 'Log exercise',
                  onTap: () {
                    _closeFabMenu();
                    context.push('/log-exercise');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FabMenuItem(
                  icon: Icons.bookmark,
                  label: 'Saved foods',
                  onTap: () {
                    _closeFabMenu();
                    context.push('/log-food', extra: {'initialTabIndex': 3});
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FabMenuItem(
                  icon: Icons.search,
                  label: 'Food Database',
                  onTap: () {
                    _closeFabMenu();
                    context.push('/log-food');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FabMenuItem(
                  icon: Icons.camera_alt,
                  label: 'Scan food',
                  onTap: () {
                    _closeFabMenu();
                    context.push('/camera');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: AppColors.textPrimary),
              const SizedBox(height: 8),
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
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppColors.success : AppColors.primary;
    final unselectedColor = isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.15) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
