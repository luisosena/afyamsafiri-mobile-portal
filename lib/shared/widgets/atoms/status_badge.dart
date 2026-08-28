import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

enum StatusType { confirmed, completed, urgent, verified, cancelled, pendingSync, draft }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  final String label;
  final StatusType type;

  Color get _backgroundColor {
    switch (type) {
      case StatusType.confirmed:
      case StatusType.completed:
      case StatusType.verified:
        return AppColors.successGreen.withValues(alpha: 0.12);
      case StatusType.urgent:
        return AppColors.urgentRed.withValues(alpha: 0.12);
      case StatusType.cancelled:
      case StatusType.pendingSync:
      case StatusType.draft:
        return AppColors.surfaceGray;
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusType.confirmed:
      case StatusType.completed:
      case StatusType.verified:
        return AppColors.successGreen;
      case StatusType.urgent:
        return AppColors.urgentRed;
      case StatusType.cancelled:
      case StatusType.pendingSync:
      case StatusType.draft:
        return AppColors.deepSlate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
