import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
              color: context.surfaceColor,
            ),
            child: Icon(
              Icons.arrow_back,
              color: context.textPrimaryColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          l10n.privacyPolicy,
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
            _buildSection(
              context,
              title: l10n.privacyIntroTitle,
              content: l10n.privacyIntroContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: l10n.privacyDataCollectionTitle,
              content: l10n.privacyDataCollectionContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: l10n.privacyDataUseTitle,
              content: l10n.privacyDataUseContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: l10n.privacyDataProtectionTitle,
              content: l10n.privacyDataProtectionContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: l10n.privacyUserRightsTitle,
              content: l10n.privacyUserRightsContent,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: l10n.privacyContactTitle,
              content: l10n.privacyContactContent,
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                l10n.privacyLastUpdated,
                style: TextStyle(
                  fontSize: 12,
                  color: context.textTertiaryColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
