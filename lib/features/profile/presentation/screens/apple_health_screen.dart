import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/health_service.dart';

class AppleHealthScreen extends ConsumerStatefulWidget {
  const AppleHealthScreen({super.key});

  @override
  ConsumerState<AppleHealthScreen> createState() => _AppleHealthScreenState();
}

class _AppleHealthScreenState extends ConsumerState<AppleHealthScreen> {
  bool _isConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final healthService = ref.read(healthServiceProvider);
    final isAuthorized = await healthService.checkAuthorization();
    setState(() {
      _isConnected = isAuthorized;
      _isLoading = false;
    });
  }

  Future<void> _connectToHealth() async {
    setState(() => _isLoading = true);

    final healthService = ref.read(healthServiceProvider);
    final success = await healthService.requestAuthorization();

    setState(() {
      _isConnected = success;
      _isLoading = false;
    });

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? l10n.healthConnected : l10n.healthConnectionFailed,
          ),
        ),
      );
    }
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
          l10n.appleHealth,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Apple Health Logo & Status
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.favorite,
                              color: Color(0xFFFF2D55),
                              size: 48,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.appleHealth,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _isConnected
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isConnected
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:
                                    _isConnected ? Colors.green : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isConnected
                                    ? l10n.connected
                                    : l10n.notConnected,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      _isConnected ? Colors.green : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.appleHealthDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Data Types Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.healthDataTypes,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Read Data
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l10n.readData,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ),
                          _DataTypeTile(
                            icon: Icons.directions_walk,
                            label: l10n.stepsData,
                            isEnabled: _isConnected,
                          ),
                          Divider(height: 1, color: context.borderColor),
                          _DataTypeTile(
                            icon: Icons.monitor_weight_outlined,
                            label: l10n.weightData,
                            isEnabled: _isConnected,
                          ),
                          Divider(height: 1, color: context.borderColor),
                          _DataTypeTile(
                            icon: Icons.local_fire_department,
                            label: l10n.activeEnergy,
                            isEnabled: _isConnected,
                          ),
                          Divider(height: 1, color: context.borderColor),
                          _DataTypeTile(
                            icon: Icons.restaurant,
                            label: l10n.nutritionData,
                            isEnabled: _isConnected,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Write Data
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l10n.writeData,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ),
                          _DataTypeTile(
                            icon: Icons.monitor_weight_outlined,
                            label: l10n.weightData,
                            isEnabled: _isConnected,
                          ),
                          Divider(height: 1, color: context.borderColor),
                          _DataTypeTile(
                            icon: Icons.restaurant,
                            label: l10n.nutritionData,
                            isEnabled: _isConnected,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Connect Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isConnected ? null : _connectToHealth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isConnected
                              ? Colors.grey
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          _isConnected
                              ? l10n.connected
                              : l10n.connectToAppleHealth,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}

class _DataTypeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;

  const _DataTypeTile({
    required this.icon,
    required this.label,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled ? AppColors.primary : context.textTertiaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          Icon(
            isEnabled ? Icons.check_circle : Icons.circle_outlined,
            color: isEnabled ? Colors.green : context.textTertiaryColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}
