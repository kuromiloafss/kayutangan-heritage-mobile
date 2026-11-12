import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
import '../viewmodels/profile_view_model.dart';
import 'edit_account_info_page.dart';

class AccountInfoPage extends StatefulWidget {
  final ProfileViewModel vm;

  const AccountInfoPage({super.key, required this.vm});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) {
        final profile = widget.vm.profil;
        if (profile == null) {
          return Scaffold(
            body: Center(
              child: Text(widget.vm.pesanError ?? 'Profil tidak tersedia'),
            ),
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
              'Informasi Akun',
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
              // Watermark pattern rumah heritage di bawah
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

              // Konten Informasi Akun
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    children: [
                      // Kartu Profil Utama (Hijau Gelap)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E3D22),
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
                            // Avatar dengan Ikon Kamera
                            Stack(
                              children: [
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
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF2E3D22),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 13,
                                      color: Color(0xFF2E3D22),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),

                            // Nama, Email & Badge Status Akun
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profile.email,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),

                                  // Badge Akun Aktif
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '• ',
                                          style: TextStyle(
                                            color: Color(0xFF81C784),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Text(
                                          'Akun Aktif',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
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

                      const SizedBox(height: 18),

                      // Kartu Rincian Informasi Profil
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(18, 16, 18, 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 20,
                                    color: Color(0xFF333333),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Informasi Profil',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF222222),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFEEEEEE)),

                            _buildDetailItem(
                              icon: Icons.person_outline_rounded,
                              label: 'Nama Lengkap',
                              value: profile.name,
                            ),
                            _buildDivider(),

                            _buildDetailItem(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: profile.email,
                            ),
                            _buildDivider(),

                            _buildDetailItem(
                              icon: Icons.phone_outlined,
                              label: 'Nomor Telepon',
                              value: profile.phone,
                            ),
                            _buildDivider(),

                            _buildDetailItem(
                              icon: Icons.calendar_today_outlined,
                              label: 'Tanggal Lahir',
                              value: profile.birthDate,
                            ),
                            _buildDivider(),

                            _buildDetailItem(
                              icon: Icons.location_on_outlined,
                              label: 'Domisili',
                              value: profile.domicile,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Tombol "Edit Informasi Akun"
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Color(0xFF4A80E2),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditAccountPage(vm: widget.vm),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Color(0xFF4A80E2),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Edit Informasi Akun',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A80E2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
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

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF444444)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Divider(height: 1, color: Color(0xFFF1F1F1)),
    );
  }
}
