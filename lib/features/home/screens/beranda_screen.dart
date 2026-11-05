import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/facility_card_tile.dart';
import '../../../shared/widgets/custom_filter_chip.dart';
import '../../facility_detail/screens/detail_fasilitas_screen.dart';
import '../../facility_list/screens/daftar_lokasi_screen.dart';
import '../../route/screens/rute_navigasi_screen.dart';
import '../../geofencing/screens/lockscreen_demo_screen.dart';
import '../../geofencing/widgets/geofence_alert_dialog.dart';

class BerandaScreen extends StatefulWidget {
  final VoidCallback onNavigateToMap;

  const BerandaScreen({super.key, required this.onNavigateToMap});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'semua';
  String _activeChip = 'terdekat'; // 'terdekat', '24jam', 'bpjs', 'ugd'

  List<FacilityModel> get _filteredFacilities {
    final query = _searchController.text.trim().toLowerCase();
    return DummyData.facilities.where((f) {
      final matchesQuery = query.isEmpty ||
          f.name.toLowerCase().contains(query) ||
          f.address.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'semua' ||
          f.category == _selectedCategory;

      bool matchesChip = true;
      if (_activeChip == '24jam') {
        matchesChip = f.openStatusText.contains('24 Jam');
      } else if (_activeChip == 'bpjs') {
        matchesChip = f.isBpjsAvailable;
      } else if (_activeChip == 'ugd') {
        matchesChip = f.isIgdAvailable;
      } else if (_activeChip == 'terdekat') {
        matchesChip = f.distanceKm <= 5.0;
      }

      return matchesQuery && matchesCategory && matchesChip;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showGeofenceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surfacePure,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Simulasi Geofencing LBS',
                style: AppTypography.headlineSm,
              ),
              const SizedBox(height: 8),
              Text(
                'Uji coba fitur deteksi radius otomatis PRD (FR-06)',
                style: AppTypography.bodySm,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.notifications_active_rounded,
                      color: AppColors.primaryContainer),
                ),
                title: Text('Simulasi Notifikasi Lockscreen',
                    style: AppTypography.labelLg),
                subtitle: Text('Layar 6: Push notification saat lockscreen',
                    style: AppTypography.bodySm),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LockscreenDemoScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.statusSuccessBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.radar_rounded,
                      color: AppColors.statusSuccessText),
                ),
                title: Text('Simulasi In-App Alert Dialog',
                    style: AppTypography.labelLg),
                subtitle: Text('Layar 10: Modal popup saat di radius 500m',
                    style: AppTypography.bodySm),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierColor: Colors.black45,
                    builder: (ctx) => GeofenceAlertDialog(
                      facility: DummyData.facilities[1], // Puskesmas Sukamaju
                      onViewLocation: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailFasilitasScreen(
                                facility: DummyData.facilities[1]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfacePure,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            color: AppColors.primaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sehat Bersama',
                              style: AppTypography.headlineSm.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Kabupaten X',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Notification & Geofence Demo Trigger
                        IconButton(
                          tooltip: 'Simulasi Geofencing',
                          icon: const Icon(Icons.notifications_none_rounded),
                          color: AppColors.secondary,
                          onPressed: _showGeofenceOptions,
                        ),
                        // Profile Avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            DummyData.userProfile.avatarUrl,
                            width: 34,
                            height: 34,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.primaryFixed,
                              child: Icon(Icons.person,
                                  size: 20, color: AppColors.primaryContainer),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Location Selector & GPS Status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryFixed,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              size: 20,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lokasi Terpilih',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Smart Village',
                                        style: AppTypography.headlineSm.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18,
                                      color: AppColors.secondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.statusSuccessBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.statusSuccessText.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.statusSuccessText,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'GPS Aktif',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.statusSuccessText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search & Filter Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceInput,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: AppColors.iconPlaceholder,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: AppTypography.bodyMd,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Cari rumah sakit, puskesmas, klinik...',
                                  hintStyle: TextStyle(
                                    color: AppColors.iconPlaceholder,
                                    fontSize: 14,
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
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColors.iconPlaceholder,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceInput,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded,
                            color: AppColors.secondary, size: 22),
                        onPressed: () {
                          // Quick toggle of categories
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Filter faskes aktif'),
                              duration: Duration(milliseconds: 1000),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Hero Highlight Emergency Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryContainer.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.emergency_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'LAYANAN TERPADU',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.primaryFixedDim,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '24 Jam',
                                    style: AppTypography.labelSm.copyWith(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Siaga Darurat Kabupaten X',
                              style: AppTypography.headlineSm.copyWith(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ambulans desa & respons cepat darurat',
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menghubungi Saluran Siaga Darurat 119...'),
                            ),
                          );
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call,
                            color: AppColors.primaryContainer,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Kategori Fasilitas',
                        style: AppTypography.headlineSm,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Pilih Kebutuhan', style: AppTypography.labelSm),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryBtn(
                      categoryKey: 'rumah-sakit',
                      label: 'Rumah Sakit',
                      icon: Icons.local_hospital_rounded,
                      bg: const Color(0xFFFFF1F2),
                      border: const Color(0xFFFFE4E6),
                      iconColor: const Color(0xFFE11D48),
                    ),
                    _buildCategoryBtn(
                      categoryKey: 'puskesmas',
                      label: 'Puskesmas',
                      icon: Icons.domain_rounded,
                      bg: const Color(0xFFECFDF5),
                      border: const Color(0xFFD1FAE5),
                      iconColor: const Color(0xFF059669),
                    ),
                    _buildCategoryBtn(
                      categoryKey: 'klinik',
                      label: 'Klinik',
                      icon: Icons.medical_services_rounded,
                      bg: const Color(0xFFEFF6FF),
                      border: const Color(0xFFDBEAFE),
                      iconColor: AppColors.primaryContainer,
                    ),
                    _buildCategoryBtn(
                      categoryKey: 'semua',
                      label: 'Semua',
                      icon: Icons.grid_view_rounded,
                      bg: const Color(0xFFF1F5F9),
                      border: const Color(0xFFE2E8F0),
                      iconColor: AppColors.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Filter Status Chips (horizontal scrolling)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    CustomFilterChip(
                      label: 'Terdekat < 5 km',
                      isSelected: _activeChip == 'terdekat',
                      trailing: _activeChip == 'terdekat'
                          ? const Icon(Icons.close_rounded,
                              size: 14, color: Colors.white)
                          : null,
                      onTap: () {
                        setState(() {
                          _activeChip =
                              _activeChip == 'terdekat' ? '' : 'terdekat';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomFilterChip(
                      label: 'Buka 24 Jam',
                      isSelected: _activeChip == '24jam',
                      onTap: () {
                        setState(() {
                          _activeChip = _activeChip == '24jam' ? '' : '24jam';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomFilterChip(
                      label: 'Terima BPJS',
                      isSelected: _activeChip == 'bpjs',
                      onTap: () {
                        setState(() {
                          _activeChip = _activeChip == 'bpjs' ? '' : 'bpjs';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomFilterChip(
                      label: 'Unit Gawat Darurat',
                      isSelected: _activeChip == 'ugd',
                      onTap: () {
                        setState(() {
                          _activeChip = _activeChip == 'ugd' ? '' : 'ugd';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Layanan Kesehatan Terdekat
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Layanan Terdekat',
                              style: AppTypography.headlineMd,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _filteredFacilities.length.toString(),
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DaftarLokasiScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Lihat Semua',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppColors.primaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Facility Cards Stack
              if (_filteredFacilities.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 40, color: AppColors.iconPlaceholder),
                        const SizedBox(height: 8),
                        Text('Fasilitas Tidak Ditemukan',
                            style: AppTypography.headlineSm),
                        const SizedBox(height: 4),
                        Text(
                          'Coba gunakan kata kunci lain atau reset filter kategori.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySm,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredFacilities.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filteredFacilities[index];
                      return FacilityCardTile(
                        facility: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailFasilitasScreen(facility: item),
                            ),
                          );
                        },
                        onDirectionsTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RuteNavigasiScreen(facility: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Sebaran Faskes Terdekat Map Callout Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Sebaran Faskes Terdekat',
                            style: AppTypography.headlineSm,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: widget.onNavigateToMap,
                          child: Text(
                            'Buka Full Peta',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: widget.onNavigateToMap,
                      child: Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Stack(
                          children: [
                            // Soft cartography background simulation
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _MiniMapGridPainter(),
                              ),
                            ),
                            // Micro pins on map
                            Positioned(
                              top: 20,
                              left: 28,
                              child: _buildMiniPin(
                                'RSUD (1.2 km)',
                                AppColors.primaryContainer,
                              ),
                            ),
                            Positioned(
                              top: 48,
                              right: 36,
                              child: _buildMiniPin(
                                'Puskesmas',
                                AppColors.statusSuccessText,
                              ),
                            ),
                            // Bottom Action Strip
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.surfacePure.withOpacity(0.96),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.borderSubtle
                                          .withOpacity(0.6)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '3 faskes dalam radius 5 km',
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Buka Peta',
                                          style: AppTypography.labelSm.copyWith(
                                            color: AppColors.primaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 14,
                                          color: AppColors.primaryContainer,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBtn({
    required String categoryKey,
    required String label,
    required IconData icon,
    required Color bg,
    required Color border,
    required Color iconColor,
  }) {
    final bool isSelected = _selectedCategory == categoryKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryKey;
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primaryContainer : border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPin(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderSubtle.withOpacity(0.5)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const double step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

