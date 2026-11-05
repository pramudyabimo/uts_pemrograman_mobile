import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum CustomButtonVariant { primary, secondary, danger, ghost }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double height;
  final double? width;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.height = 48,
    this.width,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case CustomButtonVariant.primary:
        bg = AppColors.primaryContainer;
        fg = AppColors.onPrimary;
        break;
      case CustomButtonVariant.secondary:
        bg = AppColors.surfaceSubtle;
        fg = AppColors.onSurface;
        border = const BorderSide(color: AppColors.borderSubtle);
        break;
      case CustomButtonVariant.danger:
        bg = AppColors.statusErrorBg;
        fg = AppColors.statusErrorText;
        break;
      case CustomButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.primaryContainer;
        break;
    }

    Widget content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20, color: fg),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLg.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 20, color: fg),
        ],
      ],
    );

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : width,
      child: Material(
        color: bg,
        shape: StadiumBorder(side: border),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: fg.withOpacity(0.12),
          highlightColor: fg.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}

