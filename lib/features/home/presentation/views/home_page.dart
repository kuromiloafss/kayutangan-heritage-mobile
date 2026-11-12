import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/localization/app_language.dart';
import '../components/home_header.dart';
import '../components/hero_banner.dart';
import '../components/map_access_card.dart';
import '../components/category_grid.dart';
import '../components/all_categories_dialog.dart';
import '../viewmodels/home_view_model.dart';
import '../../../category/presentation/views/category_detail_page.dart';
import '../../../category/presentation/viewmodels/category_view_model.dart';
import '../../../category/presentation/viewmodels/place_detail_view_model.dart';
import '../../../ticket/presentation/views/ticket_page.dart';
import '../../../ticket/presentation/viewmodels/ticket_view_model.dart';
import '../../../account/presentation/views/account_page.dart';
import '../../../account/presentation/viewmodels/profile_view_model.dart';
import '../../../map/presentation/views/tour_map_page.dart';
import '../../../map/presentation/viewmodels/map_view_model.dart';

class HomePage extends StatefulWidget {
  final ProfileViewModel profileViewModel;
  final CategoryViewModel categoryViewModel;
  final PlaceDetailViewModel placeDetailViewModel;
  final MapViewModel mapViewModel;
  final TicketViewModel ticketViewModel;
  final HomeViewModel homeViewModel;

  const HomePage({
    super.key,
    required this.profileViewModel,
    required this.categoryViewModel,
    required this.placeDetailViewModel,
    required this.mapViewModel,
    required this.ticketViewModel,
    required this.homeViewModel,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _navigateToCategoryDetail(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailPage(
          categoryTitle: categoryName,
          vm: widget.categoryViewModel,
          placeDetailViewModel: widget.placeDetailViewModel,
        ),
      ),
    );
  }

  void _openAllCategoriesModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) => AllCategoriesDialog(
        categories: widget.categoryViewModel.kategori,
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
        return TicketPage(vm: widget.ticketViewModel);
      case 2:
        return TourMapPage(
          placeDetailViewModel: widget.placeDetailViewModel,
          mapViewModel: widget.mapViewModel,
        );
      case 3:
        return AccountPage(
          vm: widget.profileViewModel,
          ticketViewModel: widget.ticketViewModel,
        );
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
            ListenableBuilder(
              listenable: widget.homeViewModel,
              builder: (context, _) => CategoryGrid(
                categories: widget.homeViewModel.kategori,
                onCategoryTap: _navigateToCategoryDetail,
                onSeeAllTap: _openAllCategoriesModal,
              ),
            ),
            const SizedBox(height: 36),
            const Center(
              child: Text(
                'Develop by: Calon Orang Orang Sukses',
                style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
