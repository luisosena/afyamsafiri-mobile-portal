import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/qr_utils.dart';

class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({
    super.key,
    required this.bookingID,
    required this.arrivalDate,
    required this.portOfEntry,
    this.size = 140,
    this.showLabel = true,
  });

  final String bookingID;
  final String arrivalDate;
  final String portOfEntry;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final qrData = QrUtils.generateQRData(
      bookingID: bookingID,
      arrivalDate: arrivalDate,
      portOfEntry: portOfEntry,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.deepSlate.withValues(alpha: 0.1),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            backgroundColor: AppColors.white,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.deepSlate,
            ),
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.deepSlate,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Scan to verify',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}