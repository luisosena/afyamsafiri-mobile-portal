import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../atoms/icon_button.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.showClose = false,
    this.showEdit = false,
    this.onBack,
    this.onClose,
    this.onEdit,
    this.actions,
    this.backgroundColor,
  });

  final String? title;
  final bool showBack;
  final bool showClose;
  final bool showEdit;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onEdit;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: showBack
          ? AppIconButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              size: 20,
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.heading1.copyWith(fontSize: 18),
            )
          : null,
      actions: [
        if (showEdit)
          AppIconButton(
            icon: Icons.edit_outlined,
            onPressed: onEdit,
            size: 20,
          ),
        if (showClose)
          AppIconButton(
            icon: Icons.close,
            onPressed: onClose ?? () => Navigator.of(context).pop(),
            size: 20,
          ),
        if (actions != null) ...actions!,
      ],
    );
  }
}
