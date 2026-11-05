import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/facility_model.dart';
import 'status_badge.dart';

class FacilityCardTile extends StatelessWidget {
  final FacilityModel facility;
  final VoidCallback onTap;
  final VoidCallback? onDirectionsTap;
  final VoidCallback? onFavoriteToggle;
  final bool showDirectionsButton;
  final bool showChevron;
  final bool showFavoriteButton;

  const FacilityCardTile({
    super.key,
    required this.facility,
    required this.onTap,
    this.onDirectionsTap,
    this.onFavoriteToggle,
    this.showDirectionsButton = true,
    this.showChevron = false,
    this.showFavoriteButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfacePure,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primaryContainer.withOpacity(0.06),
        highlightColor: AppColors.surfaceSubtle,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper row: Image thumbnail & facility info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail with fallback and corner radius
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 72,
                      height: 72,
                      color: AppColors.surfaceContainerLow,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            facility.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.surfaceContainer,
                                child: Center(
                                  child: Icon(
                                    Icons.local_hospital_rounded,
                                    size: 32,
                                    color: facility.pinColor,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (facility.isIgdAvailable && !showDirectionsButton)
                            Positioned(
                              bottom: 2,
                              left: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.surfacePure.withOpacity(0.92),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '24 Jam',
                                  style: AppTypography.labelSm.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.statusSuccessText,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Middle info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                facility.name,
                                style: AppTypography.headlineSm.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            StatusBadge(
                              label: facility.isOpen ? 'Buka' : 'Tutup',
                              type: facility.isOpen
                                  ? StatusBadgeType.success
                                  : StatusBadgeType.error,
                              showDot: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.near_me_rounded,
                              size: 13,
                              color: AppColors.primaryContainer,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              facility.distanceString,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: AppColors.outlineVariant,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                facility.address,
                                style: AppTypography.bodySm,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: AppColors.ratingStar,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              facility.rating.toString(),
                              style: AppTypography.labelMd.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '(${facility.reviewCount} ulasan)',
                              style: AppTypography.labelSm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Optional Right Action: Favorite heart or chevron
                  if (showFavoriteButton) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: Icon(
                        facility.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: facility.isFavorite
                            ? AppColors.statusErrorText
                            : AppColors.textMuted,
                        size: 22,
                      ),
                      onPressed: onFavoriteToggle,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ] else if (showChevron) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              // Bottom row: Service pill tags + Directions button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: facility.services.take(3).map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceInput,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (showDirectionsButton) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onDirectionsTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_rounded,
                          size: 18,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

