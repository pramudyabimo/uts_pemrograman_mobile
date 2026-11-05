import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/facility_card_tile.dart';
import '../../facility_detail/screens/detail_fasilitas_screen.dart';
import '../../route/screens/rute_navigasi_screen.dart';

class FasilitasFavoritScreen extends StatefulWidget {
  const FasilitasFavoritScreen({super.key});

  @override
  State<FasilitasFavoritScreen> createState() => _FasilitasFavoritScreenState();
}

class _FasilitasFavoritScreenState extends State<FasilitasFavoritScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';

  List<FacilityModel> get _favoriteFacilities {
    final query = _searchController.text.trim().toLowerCase();
    return DummyData.facilities.where((f) {
      final matchesQuery = query.isEmpty ||
          f.name.toLowerCase().contains(query) ||
          f.address.toLowerCase().contains(query);

      bool matchesCat = true;
      if (_selectedCategory == 'rs') {
        matchesCat = f.category == 'rumah-sakit';
      } else if (_selectedCategory == 'puskesmas') {
        matchesCat = f.category == 'puskesmas';
      } else if (_selectedCategory == 'klinik') {
        matchesCat = f.category == 'klinik';
      }

      return matchesQuery && matchesCat;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _favoriteFacilities;

    return Scaffold(
      backgroundColor: AppColors.surfacePure,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_rounded,
                            color: AppColors.primaryContainer,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fasilitas Favorit',
                                style: AppTypography.headlineMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Tersimpan untuk akses darurat cepat',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${list.where((f) => f.isFavorite).length} Faskes',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceInput,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        size: 20, color: AppColors.iconPlaceholder),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: AppTypography.bodyMd,
                        decoration: const InputDecoration(
                          hintText: 'Cari faskes tersimpan...',
                          hintStyle: TextStyle(
                            color: AppColors.iconPlaceholder,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildFilterPill('all', 'Semua'),
                  const SizedBox(width: 8),
                  _buildFilterPill('rs', 'Rumah Sakit'),
                  const SizedBox(width: 8),
                  _buildFilterPill('puskesmas', 'Puskesmas'),
                  const SizedBox(width: 8),
                  _buildFilterPill('klinik', 'Klinik Mandiri'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Facility List
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                itemCount: list.length + 1, // +1 for emergency note card at the bottom
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    // Educational Notice Banner at the bottom
                    return Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.borderSubtle.withOpacity(0.8)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.security_rounded,
                              size: 18,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Panggilan Cepat Siaga',
                                  style: AppTypography.labelMd.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Fasilitas kesehatan yang Anda tandai dengan hati merah akan selalu diprioritaskan saat menekan tombol Darurat 119.',
                                  style: AppTypography.bodySm.copyWith(
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final item = list[index];
                  return FacilityCardTile(
                    facility: item,
                    showFavoriteButton: true,
                    showDirectionsButton: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailFasilitasScreen(facility: item),
                        ),
                      );
                    },
                    onFavoriteToggle: () {
                      setState(() {
                        item.isFavorite = !item.isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(item.isFavorite
                              ? '${item.name} ditambahkan ke favorit'
                              : '${item.name} dihapus dari favorit'),
                          duration: const Duration(milliseconds: 1000),
                        ),
                      );
                    },
                    onDirectionsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RuteNavigasiScreen(facility: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String key, String label) {
    final bool isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryFixed
              : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

