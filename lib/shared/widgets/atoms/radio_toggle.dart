import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class RadioToggle extends StatelessWidget {
  const RadioToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.optionTrue = 'Yes',
    this.optionFalse = 'No',
    this.enabled = true,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final String optionTrue;
  final String optionFalse;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel.copyWith(color: AppColors.deepSlate),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: _ToggleOption(
                label: optionTrue,
                selected: value == true,
                onTap: enabled ? () => onChanged?.call(true) : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ToggleOption(
                label: optionFalse,
                selected: value == false,
                onTap: enabled ? () => onChanged?.call(false) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : AppColors.textMuted.withValues(alpha: 0.4),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.deepSlate,
          ),
        ),
      ),
    );
  }
}
