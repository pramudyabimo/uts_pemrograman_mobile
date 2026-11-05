import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/dummy/dummy_data.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/facility_card_tile.dart';
import '../../facility_detail/screens/detail_fasilitas_screen.dart';
import '../../route/screens/rute_navigasi_screen.dart';

class DaftarLokasiScreen extends StatefulWidget {
  const DaftarLokasiScreen({super.key});

  @override
  State<DaftarLokasiScreen> createState() => _DaftarLokasiScreenState();
}

class _DaftarLokasiScreenState extends State<DaftarLokasiScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all'; // 'all', 'rs', 'puskesmas', 'klinik'
  bool _isSearchVisible = true;

  List<FacilityModel> get _filteredList {
    final query = _searchController.text.trim().toLowerCase();
    return DummyData.facilities.where((f) {
      final matchesQuery = query.isEmpty ||
          f.name.toLowerCase().contains(query) ||
          f.address.toLowerCase().contains(query);

      bool matchesCategory = true;
      if (_selectedCategory == 'rs') {
        matchesCategory = f.category == 'rumah-sakit';
      } else if (_selectedCategory == 'puskesmas') {
        matchesCategory = f.category == 'puskesmas';
      } else if (_selectedCategory == 'klinik') {
        matchesCategory = f.category == 'klinik';
      }

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilter() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilities = _filteredList;

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
              'Daftar Lokasi',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Fasilitas kesehatan di sekitarmu',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.search : Icons.search_off,
              color: AppColors.onSurface,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Collapsible Search Container
            if (_isSearchVisible)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
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
                            hintText:
                                'Cari nama rumah sakit, puskesmas, klinik...',
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
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          child: const Icon(Icons.close_rounded,
                              size: 18, color: AppColors.textMuted),
                        ),
                    ],
                  ),
                ),
              ),

            // Horizontal Category Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    _buildFilterTab('all', 'Semua'),
                    const SizedBox(width: 8),
                    _buildFilterTab('rs', 'Rumah Sakit'),
                    const SizedBox(width: 8),
                    _buildFilterTab('puskesmas', 'Puskesmas'),
                    const SizedBox(width: 8),
                    _buildFilterTab('klinik', 'Klinik'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Facility List or Empty State
            Expanded(
              child: facilities.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 8.0),
                      itemCount: facilities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = facilities[index];
                        return FacilityCardTile(
                          facility: item,
                          showChevron: true,
                          showDirectionsButton: false,
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
        ),
      ),
    );
  }

  Widget _buildFilterTab(String key, String label) {
    final bool isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceInput,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_hospital_outlined,
                  size: 32, color: AppColors.primaryContainer),
            ),
            const SizedBox(height: 16),
            Text('Tidak Ditemukan', style: AppTypography.headlineSm),
            const SizedBox(height: 6),
            Text(
              'Coba gunakan kata kunci lain atau pilih kategori "Semua" untuk melihat seluruh faskes.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetFilter,
              child: const Text('Tampilkan Semua'),
            ),
          ],
        ),
      ),
    );
  }
}

