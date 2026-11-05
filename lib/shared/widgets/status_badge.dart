import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum StatusBadgeType { success, error, neutral, primary }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final bool showDot;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.success,
    this.showDot = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case StatusBadgeType.success:
        bg = AppColors.statusSuccessBg;
        fg = AppColors.statusSuccessText;
        break;
      case StatusBadgeType.error:
        bg = AppColors.statusErrorBg;
        fg = AppColors.statusErrorText;
        break;
      case StatusBadgeType.neutral:
        bg = AppColors.surfaceContainerLow;
        fg = AppColors.onSurfaceVariant;
        break;
      case StatusBadgeType.primary:
        bg = AppColors.primaryFixed;
        fg = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: fg,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

