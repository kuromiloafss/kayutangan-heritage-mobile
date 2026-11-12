import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/localization/app_language.dart';
import '../viewmodels/profile_view_model.dart';
import 'account_info_page.dart';

class SettingsPage extends StatefulWidget {
  final ProfileViewModel vm;

  const SettingsPage({super.key, required this.vm});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLanguage.tr('select_language'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              activeColor: AppColors.primary,
              title: const Text('Indonesia (ID)'),
              value: 'id',
              groupValue: AppLanguage.currentLocale.value,
              onChanged: (val) {
                if (val != null) {
                  AppLanguage.changeLanguage('id');
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<String>(
              activeColor: AppColors.primary,
              title: const Text('English (EN)'),
              value: 'en',
              groupValue: AppLanguage.currentLocale.value,
              onChanged: (val) {
                if (val != null) {
                  AppLanguage.changeLanguage('en');
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    final isId = AppLanguage.isIndonesian;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isId ? 'Tentang Aplikasi' : 'About Application',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kampung Kayutangan Heritage',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              isId
                  ? 'Versi 1.0.0\n\nAplikasi penjelajahan destinasi budaya, pemesanan tiket wisata, dan navigasi peta interaktif di Kampoeng Heritage Kayutangan Malang.'
                  : 'Version 1.0.0\n\nCultural exploration, ticket booking, and interactive map navigation app for Kampoeng Heritage Kayutangan Malang.',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isId ? 'Tutup' : 'Close',
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isId = AppLanguage.isIndonesian;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLanguage.tr('logout'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          isId
              ? 'Apakah Anda yakin ingin keluar dari akun ini?'
              : 'Are you sure you want to log out from this account?',
          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isId ? 'Batal' : 'Cancel',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text(
              AppLanguage.tr('logout'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, _, __) {
        final isId = AppLanguage.isIndonesian;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2E2E2E)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppLanguage.tr('settings'),
              style: const TextStyle(
                color: Color(0xFF2E2E2E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
          ),
          body: Stack(
            children: [
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3F6F1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_city_rounded,
                              size: 40,
                              color: Color(0xFF2C391E),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kampung Kayutangan\nHeritage',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C391E),
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isId
                                      ? 'Jelajah tempat, temukan\npengalaman baru.'
                                      : 'Explore places, discover\nnew experiences.',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9E9E9E),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _buildSettingCard(
                        icon: Icons.person_outline_rounded,
                        title: AppLanguage.tr('account'),
                        subtitle: isId
                            ? 'Informasi profil'
                            : 'Profile information',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AccountInfoPage(vm: widget.vm),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingCard(
                        icon: Icons.language_rounded,
                        title: isId ? 'Bahasa' : 'Language',
                        subtitle: isId ? 'Indonesia' : 'English',
                        onTap: _showLanguageDialog,
                      ),
                      const SizedBox(height: 18),
                      const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                      const SizedBox(height: 18),
                      _buildSettingCard(
                        icon: Icons.help_outline_rounded,
                        title: isId ? 'Bantuan' : 'Help',
                        subtitle: isId
                            ? 'Pusat bantuan dan pengaduan'
                            : 'Help center and inquiries',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Support: support@kayutangan.id'),
                              backgroundColor: Color(0xFF334227),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingCard(
                        icon: Icons.info_outline_rounded,
                        title: isId ? 'Tentang aplikasi' : 'About application',
                        subtitle: 'Versi 1.0.0',
                        onTap: _showAboutDialog,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.95),
                            side: const BorderSide(
                              color: Color(0xFFE57373),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => _showLogoutDialog(context),
                          child: Text(
                            AppLanguage.tr('logout'),
                            style: const TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
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

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF333333)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
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
}
