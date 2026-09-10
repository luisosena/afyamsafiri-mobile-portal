import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/atoms/text_input.dart';
import '../providers/screening_provider.dart';

class TravelHistoryForm extends StatefulWidget {
  const TravelHistoryForm({super.key});

  @override
  State<TravelHistoryForm> createState() => _TravelHistoryFormState();
}

class _TravelHistoryFormState extends State<TravelHistoryForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCountry(ScreeningProvider provider) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      provider.addCountry(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScreeningProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel History',
          style: AppTextStyles.heading1.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Which countries have you visited in the last 14 days?',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextInput(
                controller: _controller,
                label: 'Country',
                hint: 'e.g. Kenya',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: GestureDetector(
                onTap: () => _addCountry(provider),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(Icons.add, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        if (provider.countries.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.deepSlate.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              'No countries added yet. Add at least one country.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: provider.countries.map((country) {
              return Chip(
                label: Text(
                  country,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.deepSlate,
                  ),
                ),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => provider.removeCountry(country),
                backgroundColor: AppColors.lightAccent,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
