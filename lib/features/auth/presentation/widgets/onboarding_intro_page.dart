import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          // App Icon/Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Welcome to Dieter',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your personal nutrition companion.\nLet\'s set up your profile to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          // Features preview
          _buildFeatureItem(
            Icons.camera_alt_outlined,
            'Scan & Track',
            'Instantly log meals with AI-powered food recognition',
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.insights_outlined,
            'Smart Insights',
            'Get personalized nutrition recommendations',
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.trending_up_outlined,
            'Track Progress',
            'Monitor your journey towards your goals',
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
