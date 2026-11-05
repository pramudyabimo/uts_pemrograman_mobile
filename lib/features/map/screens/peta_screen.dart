import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/facility_model.dart';
import '../widgets/facility_map_sheet.dart';
import '../../route/screens/rute_navigasi_screen.dart';

class PetaScreen extends StatefulWidget {
  const PetaScreen({super.key});

  @override
  State<PetaScreen> createState() => _PetaScreenState();
}

class _PetaScreenState extends State<PetaScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  FacilityModel? _selectedFacility;
  bool _showGeofenceRadius = true;
  static const LatLng _userLocation = LatLng(
    DummyData.userLatitude,
    DummyData.userLongitude,
  );

  @override
  void initState() {
    super.initState();
    _selectedFacility = DummyData.facilities.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FacilityModel> get _filteredFacilities {
    final query = _searchController.text.trim().toLowerCase();
    return DummyData.facilities.where((f) {
      final matchesQuery = query.isEmpty ||
          f.name.toLowerCase().contains(query) ||
          f.address.toLowerCase().contains(query);

      bool matchesCat = true;
      if (_selectedCategory == 'RS') {
        matchesCat = f.category == 'rumah-sakit';
      } else if (_selectedCategory == 'Puskesmas') {
        matchesCat = f.category == 'puskesmas';
      } else if (_selectedCategory == 'Klinik') {
        matchesCat = f.category == 'klinik';
      }

      return matchesQuery && matchesCat;
    }).toList();
  }

  void _recenterToUser() {
    _mapController.move(_userLocation, 15.5);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Peta dipusatkan ke Lokasi Warga (Desa Sukamaju)'),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Real OpenStreetMap Interactive Tile Map
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(-6.6578, 106.8465),
                  initialZoom: 14.2,
                  minZoom: 10.0,
                  maxZoom: 18.0,
                ),
                children: [
                  // OpenStreetMap Tile Layer
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.smartvillage.sehat_bersama',
                    maxZoom: 19,
                  ),

                  // Real Geofencing Radius Circles (500m & 1000m)
                  if (_showGeofenceRadius)
                    CircleLayer(
                      circles: [
                        for (final f in _filteredFacilities) ...[
                          // Outer 1000m perimeter
                          CircleMarker(
                            point: LatLng(f.latitude, f.longitude),
                            radius: 1000,
                            useRadiusInMeter: true,
                            color: f.pinColor.withOpacity(0.06),
                            borderColor: f.pinColor.withOpacity(0.35),
                            borderStrokeWidth: 1.2,
                          ),
                          // Inner 500m alert zone
                          CircleMarker(
                            point: LatLng(f.latitude, f.longitude),
                            radius: 500,
                            useRadiusInMeter: true,
                            color: f.pinColor.withOpacity(0.14),
                            borderColor: f.pinColor,
                            borderStrokeWidth: 1.8,
                          ),
                        ],
                      ],
                    ),

                  // Marker Layer: User location + Faskes Pins
                  MarkerLayer(
                    markers: [
                      // User Current Location Marker (Live GPS / Sukamaju)
                      Marker(
                        point: _userLocation,
                        width: 56,
                        height: 56,
                        child: _buildUserLocationMarker(),
                      ),

                      // Health Facilities Pins
                      for (final f in _filteredFacilities)
                        Marker(
                          point: LatLng(f.latitude, f.longitude),
                          width: 48,
                          height: 58,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFacility = f;
                              });
                              _mapController.move(
                                LatLng(f.latitude, f.longitude),
                                15.5,
                              );
                            },
                            child: _buildFacilityMarkerPin(
                              facility: f,
                              isSelected: _selectedFacility?.id == f.id,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Top Floating Controls Area
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.surfacePure.withOpacity(0.96),
                      AppColors.surfacePure.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Sub-bar Header with Back (if canPop), Title & Real GPS Recenter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (Navigator.canPop(context))
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: AppColors.surfacePure,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_rounded,
                                  size: 20),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                            ),
                          )
                        else
                          const SizedBox(width: 38),
                        Row(
                          children: [
                            const Icon(
                              Icons.near_me_rounded,
                              color: AppColors.primaryContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Peta Lokasi',
                              style: AppTypography.headlineMd.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePure,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                              ),
                            ],
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.my_location_rounded,
                                size: 20, color: AppColors.primaryContainer),
                            onPressed: _recenterToUser,
                            padding: EdgeInsets.zero,
                            tooltip: 'Pusatkan ke Lokasi Saya',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Floating Search Bar
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePure,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                            color: AppColors.borderSubtle.withOpacity(0.8)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: AppColors.iconPlaceholder, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: AppTypography.bodyMd,
                              decoration: const InputDecoration(
                                hintText: 'Cari RSUD, Puskesmas, atau Klinik...',
                                hintStyle: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close_rounded,
                                  size: 18, color: AppColors.textMuted),
                            )
                          else
                            const Icon(Icons.tune_rounded,
                                size: 18, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category Filter Pills
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryPill('Semua'),
                          const SizedBox(width: 8),
                          _buildCategoryPill('RS'),
                          const SizedBox(width: 8),
                          _buildCategoryPill('Puskesmas'),
                          const SizedBox(width: 8),
                          _buildCategoryPill('Klinik'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Controls on Right: Zoom In, Zoom Out, Geofence Radar Toggle, OSM Watermark
            Positioned(
              right: 16,
              bottom: _selectedFacility != null ? 150 : 24,
              child: Column(
                children: [
                  _buildFloatingBtn(
                    icon: Icons.add_rounded,
                    color: AppColors.onSurface,
                    tooltip: 'Perbesar Peta',
                    onTap: _zoomIn,
                  ),
                  const SizedBox(height: 8),
                  _buildFloatingBtn(
                    icon: Icons.remove_rounded,
                    color: AppColors.onSurface,
                    tooltip: 'Perkecil Peta',
                    onTap: _zoomOut,
                  ),
                  const SizedBox(height: 8),
                  _buildFloatingBtn(
                    icon: Icons.radar_rounded,
                    color: _showGeofenceRadius
                        ? AppColors.primaryContainer
                        : AppColors.textMuted,
                    tooltip: 'Toggle Radius Geofencing (500m/1km)',
                    onTap: () {
                      setState(() {
                        _showGeofenceRadius = !_showGeofenceRadius;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_showGeofenceRadius
                              ? 'Radius Geofencing diaktifkan'
                              : 'Radius Geofencing disembunyikan'),
                          duration: const Duration(milliseconds: 700),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildFloatingBtn(
                    icon: Icons.explore_rounded,
                    color: AppColors.primaryContainer,
                    tooltip: 'Kompas Utara',
                    onTap: () {
                      _mapController.rotate(0.0);
                    },
                  ),
                ],
              ),
            ),

            // Bottom Facility Quick Preview Sheet
            if (_selectedFacility != null)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: FacilityMapSheet(
                  facility: _selectedFacility!,
                  onClose: () {
                    setState(() {
                      _selectedFacility = null;
                    });
                  },
                  onQuickRoute: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RuteNavigasiScreen(facility: _selectedFacility!),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserLocationMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulsing wave
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
        ),
        // Middle ring
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        // Core blue dot
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              size: 13,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityMarkerPin({
    required FacilityModel facility,
    required bool isSelected,
  }) {
    IconData icon;
    if (facility.category == 'puskesmas') {
      icon = Icons.local_hospital_rounded;
    } else if (facility.category == 'klinik') {
      icon = Icons.medical_services_rounded;
    } else {
      icon = Icons.healing_rounded;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 44 : 36,
          height: isSelected ? 44 : 36,
          decoration: BoxDecoration(
            color: facility.pinColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: facility.pinColor.withOpacity(0.35),
                blurRadius: isSelected ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: isSelected ? 22 : 18,
              color: Colors.white,
            ),
          ),
        ),
        // Pin pointer tip
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: facility.pinColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPill(String title) {
    final bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfacePure,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
            ),
          ],
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          title,
          style: AppTypography.labelMd.copyWith(
            color: isSelected ? Colors.white : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBtn({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.7)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
