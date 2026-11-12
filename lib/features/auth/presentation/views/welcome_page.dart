import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/localization/app_language.dart';
import '../viewmodels/auth_view_model.dart';
import '../../../account/presentation/viewmodels/profile_view_model.dart';
import '../../../category/presentation/viewmodels/category_view_model.dart';
import '../../../category/presentation/viewmodels/place_detail_view_model.dart';
import '../../../map/presentation/viewmodels/map_view_model.dart';
import '../../../ticket/presentation/viewmodels/ticket_view_model.dart';
import '../../../home/presentation/viewmodels/home_view_model.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  final AuthViewModel vm;
  final ProfileViewModel profileViewModel;
  final CategoryViewModel categoryViewModel;
  final PlaceDetailViewModel placeDetailViewModel;
  final MapViewModel mapViewModel;
  final TicketViewModel ticketViewModel;
  final HomeViewModel homeViewModel;

  const WelcomePage({
    super.key,
    required this.vm,
    required this.profileViewModel,
    required this.categoryViewModel,
    required this.placeDetailViewModel,
    required this.mapViewModel,
    required this.ticketViewModel,
    required this.homeViewModel,
  });

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder memastikan UI langsung berganti warna & bahasa saat ditekan
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, currentLang, _) {
        final bool isId = currentLang == 'id';

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // 1. Watermark pattern rumah bawah
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.85,
                    child: Image.asset(AppAssets.pattern, fit: BoxFit.fitWidth),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    children: [
                      // Switcher Pilihan Bahasa (ID / EN)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4EE),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFDCE4D6),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLangOption(
                                label: '🇮🇩 ID',
                                isSelected: isId,
                                onTap: () => AppLanguage.changeLanguage('id'),
                              ),
                              _buildLangOption(
                                label: '🇬🇧 EN',
                                isSelected: !isId,
                                onTap: () => AppLanguage.changeLanguage('en'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Logo Bulat Kayutangan
                      Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E3D22),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_city_rounded,
                          size: 46,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Kampoeng Heritage\nKayutangan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222B18),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        AppLanguage.tr('welcome_subtitle'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6B6B),
                          height: 1.45,
                        ),
                      ),

                      const Spacer(),

                      // Tombol Masuk / Login
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(
                                  vm: vm,
                                  profileViewModel: profileViewModel,
                                  categoryViewModel: categoryViewModel,
                                  placeDetailViewModel: placeDetailViewModel,
                                  mapViewModel: mapViewModel,
                                  ticketViewModel: ticketViewModel,
                                  homeViewModel: homeViewModel,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            AppLanguage.tr('login'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tombol Daftar / Register (Sudah Aktif)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(
                                  vm: vm,
                                  profileViewModel: profileViewModel,
                                  categoryViewModel: categoryViewModel,
                                  placeDetailViewModel: placeDetailViewModel,
                                  mapViewModel: mapViewModel,
                                  ticketViewModel: ticketViewModel,
                                  homeViewModel: homeViewModel,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            AppLanguage.tr('register'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF334227) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF4A4A4A),
          ),
        ),
      ),
    );
  }
}
