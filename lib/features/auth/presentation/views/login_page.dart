import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/components/app_button.dart';
import '../../../../core/components/text_input.dart';
import '../../../../core/localization/app_language.dart';
import '../viewmodels/auth_view_model.dart';
import '../../../account/presentation/viewmodels/profile_view_model.dart';
import '../../../category/presentation/viewmodels/category_view_model.dart';
import '../../../category/presentation/viewmodels/place_detail_view_model.dart';
import '../../../map/presentation/viewmodels/map_view_model.dart';
import '../../../ticket/presentation/viewmodels/ticket_view_model.dart';
import '../../../home/presentation/viewmodels/home_view_model.dart';
import 'register_page.dart';
import '../../../home/presentation/views/home_page.dart';

class LoginPage extends StatefulWidget {
  final AuthViewModel vm;
  final ProfileViewModel profileViewModel;
  final CategoryViewModel categoryViewModel;
  final PlaceDetailViewModel placeDetailViewModel;
  final MapViewModel mapViewModel;
  final TicketViewModel ticketViewModel;
  final HomeViewModel homeViewModel;

  const LoginPage({
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
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State untuk sembunyikan / tampilkan password
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final loggedIn = widget.vm.login(
      identifier: _identifierController.text,
      password: _passwordController.text,
      languageCode: AppLanguage.currentLocale.value,
    );
    if (!loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.vm.pesanError ?? ''),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      _createSmoothRoute(
        HomePage(
          profileViewModel: widget.profileViewModel,
          categoryViewModel: widget.categoryViewModel,
          placeDetailViewModel: widget.placeDetailViewModel,
          mapViewModel: widget.mapViewModel,
          ticketViewModel: widget.ticketViewModel,
          homeViewModel: widget.homeViewModel,
        ),
      ),
    );
  }

  // Animasi transisi halus (Fade + Slide Up)
  Route _createSmoothRoute(Widget targetPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.08),
          end: Offset.zero,
        ).animate(curve);

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curve);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Watermark pattern rumah di bagian bawah
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

          // 2. Konten formulir login
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo Kayutangan
                    Image.asset(
                      AppAssets.logoLogin,
                      width: 220,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 36),

                    // Judul & Subjudul
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk untuk melanjutkan perjalanan menjelajahi\nKayutangan Heritage.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Input Email atau Nomor Telepon
                    TextInput(
                      controller: _identifierController,
                      hintText: 'Email atau nomor telepon',
                      prefixIcon: Icons.mail_outline_rounded,
                    ),

                    const SizedBox(height: 16),

                    // Input Password dengan toggle ikon mata
                    TextInput(
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Login
                    ListenableBuilder(
                      listenable: widget.vm,
                      builder: (context, _) =>
                          AppButton(text: 'Login', onPressed: _handleLogin),
                    ),

                    const SizedBox(height: 16),

                    // Link navigasi ke halaman Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              _createSmoothRoute(
                                RegisterPage(
                                  vm: widget.vm,
                                  profileViewModel: widget.profileViewModel,
                                  categoryViewModel: widget.categoryViewModel,
                                  placeDetailViewModel:
                                      widget.placeDetailViewModel,
                                  mapViewModel: widget.mapViewModel,
                                  ticketViewModel: widget.ticketViewModel,
                                  homeViewModel: widget.homeViewModel,
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLink,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Jarak batas bawah agar tidak bertumpuk dengan gambar
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
