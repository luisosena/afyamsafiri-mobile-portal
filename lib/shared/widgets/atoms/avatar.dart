import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
  });

  final String? imageUrl;
  final String? name;
  final double size;

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightAccent,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null
          ? Text(
              _initials,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.38,
              ),
            )
          : null,
    );
  }
}
