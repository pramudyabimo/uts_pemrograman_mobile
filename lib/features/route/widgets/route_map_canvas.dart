import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/facility_model.dart';

class RouteMapCanvas extends StatelessWidget {
  final FacilityModel facility;
  final String estimatedTime;
  final String estimatedDist;
  final String trafficStatus;
  final bool isAudioMuted;
  final VoidCallback onToggleAudio;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const RouteMapCanvas({
    super.key,
    required this.facility,
    required this.estimatedTime,
    required this.estimatedDist,
    required this.trafficStatus,
    required this.isAudioMuted,
    required this.onToggleAudio,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Origin (user) and destination (hospital)
        final userOffset = Offset(w * 0.22, h * 0.78);
        final destOffset = Offset(w * 0.78, h * 0.22);

        return Stack(
          children: [
            // Map Canvas Base & Polyline Route
            Positioned.fill(
              child: CustomPaint(
                painter: _RoutePolylinePainter(
                  start: userOffset,
                  end: destOffset,
                ),
              ),
            ),

            // User Origin Pin
            Positioned(
              left: userOffset.dx - 45,
              top: userOffset.dy - 16,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      'Lokasi Anda',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Destination Pin (Hospital)
            Positioned(
              left: destOffset.dx - 45,
              top: destOffset.dy - 55,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.statusErrorText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          facility.name,
                          style: AppTypography.labelSm.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating Quick Route Metric Pill (Top Left)
            Positioned(
              top: 14,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.statusSuccessText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$estimatedTime • $estimatedDist',
                      style: AppTypography.labelMd.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($trafficStatus)',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sound Toggle (Top Right)
            Positioned(
              top: 14,
              right: 16,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isAudioMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    size: 18,
                    color: AppColors.onSurface,
                  ),
                  onPressed: onToggleAudio,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),

            // Zoom In / Out Controls (Bottom Right)
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  _buildZoomBtn(Icons.add, onZoomIn),
                  const SizedBox(height: 6),
                  _buildZoomBtn(Icons.remove, onZoomOut),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildZoomBtn(IconData icon, VoidCallback onTap) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: AppColors.onSurface),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _RoutePolylinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  _RoutePolylinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    // Background terrain
    final bgPaint = Paint()..color = const Color(0xFFD7E2F8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Subtle Road Grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 10;

    canvas.drawLine(Offset(-20, size.height * 0.4), Offset(size.width + 20, size.height * 0.45), gridPaint);
    canvas.drawLine(Offset(size.width * 0.35, -20), Offset(size.width * 0.4, size.height + 20), gridPaint);
    canvas.drawLine(Offset(size.width * 0.7, -20), Offset(size.width * 0.65, size.height + 20), gridPaint);

    // Polyline Path with smooth curve
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        start.dx + 40,
        start.dy - 80,
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
      )
      ..quadraticBezierTo(
        end.dx - 30,
        end.dy + 70,
        end.dx,
        end.dy,
      );

    // Shadow Route Glow
    final glowPaint = Paint()
      ..color = AppColors.primaryContainer.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Active Route Line
    final activePaint = Paint()
      ..color = AppColors.primaryContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Traffic segment (green portion representing smooth segment in the middle)
    final trafficPaint = Paint()
      ..color = AppColors.statusSuccessText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, activePaint);

    // Draw small green traffic segment in the mid-route
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;
    canvas.drawLine(
      Offset(midX - 25, midY + 15),
      Offset(midX + 25, midY - 20),
      trafficPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

