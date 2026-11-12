import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/localization/app_language.dart';
import 'components/home_header.dart';
import 'components/hero_banner.dart';
import 'components/map_access_card.dart';
import 'components/category_grid.dart';
import 'components/all_categories_dialog.dart';
import '../category/category_detail_page.dart';
import '../ticket/ticket_page.dart';
import '../account/account_page.dart';
import '../map/tour_map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _navigateToCategoryDetail(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailPage(categoryTitle: categoryName),
      ),
    );
  }

  void _openAllCategoriesModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) => AllCategoriesDialog(
        onCategoryTap: (categoryName) {
          _navigateToCategoryDetail(categoryName);
        },
      ),
    );
  }

  // Lazy rendering agar saat app pertama dibuka tidak freeze/berat
  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const TicketPage();
      case 2:
        return const TourMapPage();
      case 3:
        return const AccountPage();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _getCurrentPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: const Color(0xFF9E9E9E),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 8,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: AppLanguage.tr('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.confirmation_num_outlined),
                activeIcon: const Icon(Icons.confirmation_num),
                label: AppLanguage.tr('ticket'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_on_outlined),
                activeIcon: const Icon(Icons.location_on),
                label: AppLanguage.tr('tour_map'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: AppLanguage.tr('account'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 18),
            const HeroBanner(),
            const SizedBox(height: 16),
            MapAccessCard(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            const SizedBox(height: 22),
            CategoryGrid(
              onCategoryTap: _navigateToCategoryDetail,
              onSeeAllTap: _openAllCategoriesModal,
            ),
            const SizedBox(height: 36),
            const Center(
              child: Text(
                'Develop by: Calon Orang Orang Sukses',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}