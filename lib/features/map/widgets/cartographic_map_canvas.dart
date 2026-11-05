import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/facility_model.dart';

class CartographicMapCanvas extends StatelessWidget {
  final List<FacilityModel> facilities;
  final FacilityModel? selectedFacility;
  final ValueChanged<FacilityModel> onSelectFacility;
  final bool showGeofenceRadius;

  const CartographicMapCanvas({
    super.key,
    required this.facilities,
    required this.selectedFacility,
    required this.onSelectFacility,
    this.showGeofenceRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // Base Cartographic Map Painter (roads, river, blocks)
            Positioned.fill(
              child: CustomPaint(
                painter: _VillageCartographyPainter(),
              ),
            ),

            // Geofence Radar Rings around User Location (center-ish)
            if (showGeofenceRadius)
              Positioned(
                left: w * 0.48 - 80,
                top: h * 0.52 - 80,
                child: IgnorePointer(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryContainer.withOpacity(0.08),
                      border: Border.all(
                        color: AppColors.primaryContainer.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

            // User Location Pulse Core
            Positioned(
              left: w * 0.48 - 14,
              top: h * 0.52 - 14,
              child: IgnorePointer(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePure,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Facility Pins
            for (final f in facilities)
              Positioned(
                left: (w * f.mapXPercent) - 60,
                top: (h * f.mapYPercent) - 45,
                child: GestureDetector(
                  onTap: () => onSelectFacility(f),
                  child: SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tooltip Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfacePure,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: selectedFacility?.id == f.id
                                  ? f.pinColor
                                  : AppColors.borderSubtle.withOpacity(0.6),
                              width: selectedFacility?.id == f.id ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: f.pinColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  f.name,
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Custom Pin Badge
                        _buildPinGraphic(f, isSelected: selectedFacility?.id == f.id),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPinGraphic(FacilityModel f, {required bool isSelected}) {
    return AnimatedScale(
      scale: isSelected ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 180),
      child: Container(
        width: 32,
        height: 38,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: f.pinColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 38,
              color: f.pinColor,
            ),
            Positioned(
              top: 7,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 11,
                  color: f.pinColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VillageCartographyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF1F3FF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // City grid pattern
    final gridPaint = Paint()
      ..color = const Color(0xFFE1E8FD)
      ..strokeWidth = 0.75;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Village Urban Blocks
    final blockPaintA = Paint()..color = const Color(0xFFE4EAFE);
    final blockPaintB = Paint()..color = const Color(0xFFE9EDFF);
    final parkPaint = Paint()..color = const Color(0xFFD6F5E3);

    // Blocks
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.08, size.height * 0.10,
                size.width * 0.35, size.height * 0.12),
            const Radius.circular(8)),
        blockPaintA);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.52, size.height * 0.06,
                size.width * 0.40, size.height * 0.14),
            const Radius.circular(8)),
        blockPaintB);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.06, size.height * 0.35,
                size.width * 0.34, size.height * 0.16),
            const Radius.circular(8)),
        blockPaintB);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.58, size.height * 0.32,
                size.width * 0.36, size.height * 0.18),
            const Radius.circular(8)),
        blockPaintA);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.08, size.height * 0.62,
                size.width * 0.36, size.height * 0.20),
            const Radius.circular(8)),
        blockPaintA);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.55, size.height * 0.60,
                size.width * 0.38, size.height * 0.22),
            const Radius.circular(8)),
        blockPaintB);

    // Botanical Green Belts (parks)
    canvas.drawCircle(
        Offset(size.width * 0.22, size.height * 0.42), 34, parkPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.65, size.height * 0.12, 70, 35),
            const Radius.circular(10)),
        parkPaint);

    // River Waterway
    final riverPath = Path()
      ..moveTo(-20, size.height * 0.26)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.28,
          size.width * 0.45, size.height * 0.38)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.52,
          size.width + 20, size.height * 0.60);

    final riverPaint = Paint()
      ..color = const Color(0xFFC5DCFE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final riverHighlight = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(riverPath, riverPaint);
    canvas.drawPath(riverPath, riverHighlight);

    // Primary Arterial Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD1DBF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Vertical Main Road
    canvas.drawLine(
        Offset(size.width * 0.48, -20), Offset(size.width * 0.48, size.height + 20), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.48, -20), Offset(size.width * 0.48, size.height + 20), roadBorderPaint);

    // Horizontal Main Road
    canvas.drawLine(
        Offset(-20, size.height * 0.52), Offset(size.width + 20, size.height * 0.52), roadPaint);
    canvas.drawLine(
        Offset(-20, size.height * 0.52), Offset(size.width + 20, size.height * 0.52), roadBorderPaint);

    // Secondary Cross Roads
    final subRoad = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawLine(
        Offset(-20, size.height * 0.20), Offset(size.width + 20, size.height * 0.18), subRoad);
    canvas.drawLine(
        Offset(-20, size.height * 0.78), Offset(size.width + 20, size.height * 0.80), subRoad);
    canvas.drawLine(
        Offset(size.width * 0.20, -20), Offset(size.width * 0.26, size.height + 20), subRoad);
    canvas.drawLine(
        Offset(size.width * 0.80, -20), Offset(size.width * 0.76, size.height + 20), subRoad);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

