import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
import '../../../ticket/presentation/views/my_tickets_page.dart';
import '../../../ticket/presentation/viewmodels/ticket_view_model.dart';
import 'account_info_page.dart';
import 'settings_page.dart';
import '../viewmodels/profile_view_model.dart';

class AccountPage extends StatelessWidget {
  final ProfileViewModel vm;
  final TicketViewModel ticketViewModel;

  const AccountPage({
    super.key,
    required this.vm,
    required this.ticketViewModel,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar Akun',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
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
              // Kembali ke halaman Login dan hapus seluruh riwayat navigasi
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(
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
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final profile = vm.profil;
        if (profile == null) {
          return Scaffold(
            body: Center(child: Text(vm.pesanError ?? 'Profil tidak tersedia')),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2E2E2E)),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Akun',
              style: TextStyle(
                color: Color(0xFF2E2E2E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
          ),
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

              // 2. Konten Halaman Akun
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    children: [
                      // Kartu Info Pengguna Hijau Gelap
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3D22), // Hijau army pekat
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar Bulat Putih
                            Container(
                              width: 66,
                              height: 66,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                size: 40,
                                color: Color(0xFF2E3D22),
                              ),
                            ),
                            const SizedBox(width: 18),

                            // Nama & Email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    profile.email,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Menu List Navigasi
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Menu 1: Informasi Profil (Membuka AccountInfoPage)
                            _buildMenuItem(
                              icon: Icons.person_outline_rounded,
                              title: 'Informasi Profil',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AccountInfoPage(vm: vm),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F1F1),
                            ),

                            // Menu 2: Tiket Saya (Membuka MyTicketsPage)
                            _buildMenuItem(
                              icon: Icons.confirmation_num_outlined,
                              title: 'Tiket Saya',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyTicketsPage(vm: ticketViewModel),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F1F1),
                            ),

                            // Menu 3: Pengaturan
                            _buildMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Pengaturan',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsPage(vm: vm),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Tombol Logout
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
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: Icon(icon, color: const Color(0xFF2E2E2E), size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF222222),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF888888),
        size: 20,
      ),
    );
  }
}
