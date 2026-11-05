import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../home/screens/beranda_screen.dart';
import '../../map/screens/peta_screen.dart';
import '../../favorites/screens/fasilitas_favorit_screen.dart';
import '../../profile/screens/profil_screen.dart';

class MainScaffoldScreen extends StatefulWidget {
  final int initialIndex;

  const MainScaffoldScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScaffoldScreen> createState() => MainScaffoldScreenState();

  static MainScaffoldScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainScaffoldScreenState>();
  }
}

class MainScaffoldScreenState extends State<MainScaffoldScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BerandaScreen(onNavigateToMap: () => switchTab(1)),
      const PetaScreen(),
      const FasilitasFavoritScreen(),
      const ProfilScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, -2),
              blurRadius: 12,
            ),
          ],
          border: const Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Beranda'),
                _buildNavItem(1, Icons.location_on_rounded, 'Peta'),
                _buildNavItem(2, Icons.favorite_rounded, 'Favorit'),
                _buildNavItem(3, Icons.person_rounded, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    final Color color =
        isSelected ? AppColors.primaryContainer : AppColors.textMuted;

    return InkWell(
      onTap: () => switchTab(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

