import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({
    super.key,
    required this.synced,
    this.syncFailed = false,
    this.size = 10,
  });

  final bool synced;
  final bool syncFailed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = syncFailed
        ? AppColors.urgentRed
        : synced
            ? AppColors.successGreen
            : AppColors.warningYellow;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}