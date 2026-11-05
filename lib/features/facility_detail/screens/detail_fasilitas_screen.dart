import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/service_sheet_modal.dart';
import '../../route/screens/rute_navigasi_screen.dart';

class DetailFasilitasScreen extends StatefulWidget {
  final FacilityModel facility;

  const DetailFasilitasScreen({super.key, required this.facility});

  @override
  State<DetailFasilitasScreen> createState() => _DetailFasilitasScreenState();
}

class _DetailFasilitasScreenState extends State<DetailFasilitasScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.facility.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.facility.isFavorite = _isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isFavorite ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _isFavorite
                  ? 'Disimpan ke fasilitas favorit!'
                  : 'Dihapus dari fasilitas favorit',
            ),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
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
        title: Text(
          'Detail Fasilitas',
          style: AppTypography.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: _isFavorite ? AppColors.primaryContainer : AppColors.secondary,
            ),
            onPressed: _toggleFavorite,
            tooltip: 'Simpan ke favorit',
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.secondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tautan fasilitas ${f.name} disalin ke clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Bagikan fasilitas',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Section with Visual & Overlay Badges
                    Stack(
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          color: AppColors.surfaceContainerLow,
                          child: Image.network(
                            f.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.surfaceContainer,
                              child: const Icon(
                                Icons.local_hospital_rounded,
                                size: 64,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                          ),
                        ),
                        // Top and bottom gradient scrims
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.2),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.55),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Bottom Hero Accreditation Tag
                        Positioned(
                          bottom: 12,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfacePure.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.borderSubtle.withOpacity(0.6)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.statusSuccessText,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  f.accreditation,
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Primary Facility Profile Info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: AppTypography.headlineLg.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: AppColors.ratingStar,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    f.rating.toString(),
                                    style: AppTypography.labelLg.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${f.reviewCount} ulasan)',
                                    style: AppTypography.bodySm,
                                  ),
                                ],
                              ),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: AppColors.outlineVariant,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.near_me_rounded,
                                    size: 15,
                                    color: AppColors.primaryContainer,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${f.distanceString} dari Anda',
                                    style: AppTypography.labelMd.copyWith(
                                      color: AppColors.primaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Status Badges
                          Row(
                            children: [
                              StatusBadge(
                                label: f.openStatusText,
                                type: StatusBadgeType.success,
                                showDot: true,
                              ),
                              const SizedBox(width: 8),
                              if (f.isIgdAvailable)
                                const StatusBadge(
                                  label: 'IGD 24 Jam Siaga',
                                  type: StatusBadgeType.error,
                                  icon: Icons.emergency_rounded,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Address & Location Callout
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryFixed.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: AppColors.primaryContainer,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.addressDetail,
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Contact Action Strip
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildContactAction(
                              icon: Icons.call_rounded,
                              label: 'Darurat',
                              value: '${f.phoneEmergency} / IGD',
                              valueColor: AppColors.statusErrorText,
                              iconBg: AppColors.statusErrorBg,
                              iconColor: AppColors.statusErrorText,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Menghubungi IGD Darurat ${f.phoneEmergency}'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildContactAction(
                              icon: Icons.phone_in_talk_rounded,
                              label: 'Pusat Info',
                              value: f.phoneInfo,
                              iconBg: AppColors.primaryFixed,
                              iconColor: AppColors.primaryContainer,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Nomor ${f.phoneInfo} disalin'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildContactAction(
                              icon: Icons.schedule_rounded,
                              label: 'Jadwal Poli',
                              value: '08.00 - 15.00',
                              iconBg: AppColors.secondaryContainer,
                              iconColor: AppColors.secondary,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Poli Rawat Jalan: Senin - Sabtu 08:00 - 15:00 WIB'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Soft Tint Divider Bar
                    Container(height: 6, color: AppColors.surfaceSubtle),
                    const SizedBox(height: 16),

                    // Jenis Pelayanan Section (8 Grid)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jenis Pelayanan',
                                        style: AppTypography.headlineSm),
                                    Text(
                                      'Fasilitas terpadu dan layanan medis siap tanggap',
                                      style: AppTypography.bodySm,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFixed,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${DummyData.hospitalServices.length} Layanan',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 8 Service Widgets Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: DummyData.hospitalServices.length,
                            itemBuilder: (context, index) {
                              final item = DummyData.hospitalServices[index];
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) =>
                                        ServiceSheetModal(service: item),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: item.isEmergency
                                            ? AppColors.statusErrorBg
                                            : AppColors.primaryFixed.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: item.isEmergency
                                              ? AppColors.statusErrorText
                                                  .withOpacity(0.3)
                                              : AppColors.borderSubtle,
                                        ),
                                      ),
                                      child: Icon(
                                        item.icon,
                                        size: 24,
                                        color: item.isEmergency
                                            ? AppColors.statusErrorText
                                            : AppColors.primaryContainer,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.shortName,
                                      style: AppTypography.labelSm.copyWith(
                                        fontWeight: item.isEmergency
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item.subtitle,
                                      style: AppTypography.labelSm.copyWith(
                                        fontSize: 10,
                                        color: item.isEmergency
                                            ? AppColors.statusErrorText
                                            : AppColors.textMuted,
                                        fontWeight: item.isEmergency
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Information Notice Banner (BPJS)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryContainer.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fasilitas Rekanan BPJS Kesehatan',
                                    style: AppTypography.labelMd.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Melayani rujukan JKN-KIS dari FKTP tingkat 1 (Puskesmas/Klinik) serta penanganan gawat darurat tanpa rujukan awal.',
                                    style: AppTypography.bodySm.copyWith(
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Static Map Snapshot Preview
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Lokasi di Area',
                                    style: AppTypography.headlineSm),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RuteNavigasiScreen(facility: f),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Buka Navigasi →',
                                  style: AppTypography.labelMd.copyWith(
                                    color: AppColors.primaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RuteNavigasiScreen(facility: f),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: AppColors.borderSubtle),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    FlutterMap(
                                      options: MapOptions(
                                        initialCenter:
                                            LatLng(f.latitude, f.longitude),
                                        initialZoom: 15.0,
                                        interactionOptions:
                                            const InteractionOptions(
                                          flags: InteractiveFlag.none,
                                        ),
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          userAgentPackageName:
                                              'com.smartvillage.sehat_bersama',
                                          maxZoom: 19,
                                        ),
                                        CircleLayer(
                                          circles: [
                                           CircleMarker(
                                              point: LatLng(
                                                  f.latitude, f.longitude),
                                              radius: 500,
                                              useRadiusInMeter: true,
                                              color:
                                                  f.pinColor.withOpacity(0.18),
                                              borderColor: f.pinColor,
                                              borderStrokeWidth: 1.5,
                                            ),
                                          ],
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: LatLng(
                                                  f.latitude, f.longitude),
                                              width: 38,
                                              height: 38,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: f.pinColor,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.local_hospital_rounded,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Overlay badge at bottom
                                    Positioned(
                                      bottom: 10,
                                      left: 12,
                                      right: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.92),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.radar_rounded,
                                                    size: 14,
                                                    color: f.pinColor,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Flexible(
                                                    child: Text(
                                                      'Radius Geofence 500m',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppTypography
                                                          .labelSm
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Buka Rute →',
                                              style: AppTypography.labelSm
                                                  .copyWith(
                                                color:
                                                    AppColors.primaryContainer,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

            // Bottom Sticky Bar (Call & Route Button)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfacePure,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: const Border(
                  top: BorderSide(color: AppColors.borderSubtle, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.call_rounded,
                          color: AppColors.primaryContainer, size: 22),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Menghubungi ${f.name} di ${f.phoneEmergency}'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Buka di Peta & Rute',
                      leadingIcon: Icons.near_me_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RuteNavigasiScreen(facility: f),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactAction({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBg,
    required Color iconColor,
    Color? valueColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                color: valueColor ?? AppColors.textMuted,
                fontWeight: valueColor != null ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

