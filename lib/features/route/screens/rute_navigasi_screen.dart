import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/custom_button.dart';

enum TransportMode { car, motor, walk }

class RuteNavigasiScreen extends StatefulWidget {
  final FacilityModel facility;

  const RuteNavigasiScreen({super.key, required this.facility});

  @override
  State<RuteNavigasiScreen> createState() => _RuteNavigasiScreenState();
}

class _RuteNavigasiScreenState extends State<RuteNavigasiScreen> {
  final MapController _routeMapController = MapController();
  TransportMode _selectedMode = TransportMode.car;
  bool _isAudioMuted = false;
  bool _isNavigating = false;
  static const LatLng _userLocation = LatLng(
    DummyData.userLatitude,
    DummyData.userLongitude,
  );

  String get _estimatedTime {
    switch (_selectedMode) {
      case TransportMode.car:
        return '4 menit';
      case TransportMode.motor:
        return '15 mnt';
      case TransportMode.walk:
        return '6 menit';
    }
  }

  String get _estimatedDist {
    switch (_selectedMode) {
      case TransportMode.car:
        return '1.2 km';
      case TransportMode.motor:
        return '1.1 km';
      case TransportMode.walk:
        return '1.2 km';
    }
  }

  String get _trafficNote {
    switch (_selectedMode) {
      case TransportMode.car:
        return 'Jalur utama lancar tanpa hambatan';
      case TransportMode.motor:
        return 'Padat merayap di simpang pasar';
      case TransportMode.walk:
        return 'Jalur pedestrian desa ramah pejalan';
    }
  }

  List<LatLng> get _routePoints {
    final start = _userLocation;
    final end = LatLng(widget.facility.latitude, widget.facility.longitude);

    // Realistic road waypoints connecting user to destination in Ciawi area
    final midLat1 = start.latitude + (end.latitude - start.latitude) * 0.35;
    final midLng1 = start.longitude + (end.longitude - start.longitude) * 0.15;

    final midLat2 = start.latitude + (end.latitude - start.latitude) * 0.70;
    final midLng2 = start.longitude + (end.longitude - start.longitude) * 0.85;

    return [
      start,
      LatLng(midLat1, midLng1),
      LatLng(midLat2, midLng2),
      end,
    ];
  }

  LatLng get _routeCenter {
    final start = _userLocation;
    final end = LatLng(widget.facility.latitude, widget.facility.longitude);
    return LatLng(
      (start.latitude + end.latitude) / 2,
      (start.longitude + end.longitude) / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.facility;

    return Scaffold(
      backgroundColor: AppColors.surfacePure,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rute ke ${f.name}',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Navigasi GPS Presisi Real-time',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: IconButton(
              icon: const Icon(Icons.explore_rounded,
                  size: 18, color: AppColors.primaryContainer),
              onPressed: () {
                _routeMapController.rotate(0.0);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kompas Navigasi disesuaikan ke Utara'),
                    duration: Duration(milliseconds: 800),
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map Viewport (Real OpenStreetMap with Route Polyline)
            SizedBox(
              height: 290,
              width: double.infinity,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _routeMapController,
                    options: MapOptions(
                      initialCenter: _routeCenter,
                      initialZoom: 14.5,
                      minZoom: 11.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      // OpenStreetMap Real Map Tile
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.smartvillage.sehat_bersama',
                        maxZoom: 19,
                      ),

                      // Navigation Route Polyline
                      PolylineLayer(
                        polylines: [
                          // Outer shadow glow line
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 7.0,
                            color: AppColors.primaryContainer.withOpacity(0.35),
                          ),
                          // Inner sharp route line
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 4.5,
                            color: AppColors.primaryContainer,
                          ),
                        ],
                      ),

                      // Markers: Start Point (User) and Destination (Hospital)
                      MarkerLayer(
                        markers: [
                          // Start (Live GPS / Sukamaju)
                          Marker(
                            point: _userLocation,
                            width: 38,
                            height: 38,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.statusSuccessText,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.my_location_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Finish (Hospital Pin)
                          Marker(
                            point: LatLng(f.latitude, f.longitude),
                            width: 44,
                            height: 52,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: f.pinColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: f.pinColor.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.local_hospital_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: f.pinColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Top Turn-by-Turn Maneuver Bubble
                  Positioned(
                    top: 12,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.onSurface.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.turn_right_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Belok kanan ke Jl. Raya Puncak Gadog',
                                  style: AppTypography.labelMd.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '120 m • Masuk jalur ambulans darurat',
                                  style: AppTypography.bodySm.copyWith(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Map Action Buttons: Audio Mute & Recenter
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMapActionButton(
                          icon: _isAudioMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          color: _isAudioMuted
                              ? AppColors.textMuted
                              : AppColors.primaryContainer,
                          onTap: () {
                            setState(() {
                              _isAudioMuted = !_isAudioMuted;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isAudioMuted
                                    ? 'Panduan suara dimatikan'
                                    : 'Panduan suara diaktifkan'),
                                duration: const Duration(milliseconds: 700),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        _buildMapActionButton(
                          icon: Icons.center_focus_strong_rounded,
                          color: AppColors.onSurface,
                          onTap: () {
                            _routeMapController.move(_routeCenter, 14.5);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Route Destination Summary Card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        f.photoUrl,
                        width: 58,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 58,
                          height: 48,
                          color: AppColors.surfaceContainerLow,
                          child: Icon(Icons.local_hospital_rounded,
                              color: f.pinColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Tujuan Rujukan',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.primaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.statusSuccessBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'IGD Buka 24 Jam',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.statusSuccessText,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            f.name,
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            f.address,
                            style: AppTypography.bodySm.copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Transport Mode & Navigation Sheet
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                decoration: BoxDecoration(
                  color: AppColors.surfacePure,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  border: const Border(
                    top: BorderSide(color: AppColors.borderSubtle, width: 0.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Header Info in Sheet
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pilih Mode Transportasi',
                                    style: AppTypography.headlineSm.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Estimasi: $_estimatedTime ($_estimatedDist) • Rute tercepat',
                                    style: AppTypography.bodySm
                                        .copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.info_outline_rounded,
                                  size: 18, color: AppColors.textMuted),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Transport Mode Selector (3 options)
                        Row(
                          children: [
                            Expanded(
                              child: _buildTransportBtn(
                                mode: TransportMode.car,
                                icon: Icons.directions_car_rounded,
                                time: '4 mnt',
                                dist: '1.2 km',
                                label: 'Mobil',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTransportBtn(
                                mode: TransportMode.motor,
                                icon: Icons.two_wheeler_rounded,
                                time: '15 mnt',
                                dist: '1.1 km',
                                label: 'Motor',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTransportBtn(
                                mode: TransportMode.walk,
                                icon: Icons.directions_walk_rounded,
                                time: '6 mnt',
                                dist: '1.2 km',
                                label: 'Jalan Kaki',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Route details card
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryFixed
                                            .withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.traffic_rounded,
                                        size: 18,
                                        color: AppColors.primaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kondisi Jalan Raya',
                                            style:
                                                AppTypography.labelSm.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            _trafficNote,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodySm.copyWith(
                                              fontSize: 11,
                                              color: _selectedMode ==
                                                      TransportMode.motor
                                                  ? AppColors.ratingStar
                                                  : AppColors.statusSuccessText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  size: 18, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Primary Action Button: Start Navigation
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomButton(
                        text: _isNavigating
                            ? 'Hentikan Navigasi'
                            : 'Mulai Navigasi',
                        leadingIcon: _isNavigating
                            ? Icons.stop_circle_rounded
                            : Icons.navigation_rounded,
                        variant: _isNavigating
                            ? CustomButtonVariant.danger
                            : CustomButtonVariant.primary,
                        onPressed: () {
                          setState(() {
                            _isNavigating = !_isNavigating;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isNavigating
                                  ? 'Navigasi GPS ke ${f.name} dimulai'
                                  : 'Navigasi dihentikan'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: color),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildTransportBtn({
    required TransportMode mode,
    required IconData icon,
    required String time,
    required String dist,
    required String label,
  }) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chipActiveBg : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer.withOpacity(0.12)
                    : AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppTypography.headlineSm.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.onSurface,
              ),
            ),
            Text(
              dist,
              style: AppTypography.labelSm.copyWith(
                fontSize: 11,
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label.toUpperCase(),
                style: AppTypography.labelSm.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
