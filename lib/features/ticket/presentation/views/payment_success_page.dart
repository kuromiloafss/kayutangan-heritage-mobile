import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/assets.dart';
import '../../domain/entities/ticket.dart';
import '../viewmodels/ticket_view_model.dart';
import 'my_tickets_page.dart';

class PaymentSuccessPage extends StatefulWidget {
  final TicketViewModel vm;
  final Ticket ticket;

  const PaymentSuccessPage({super.key, required this.vm, required this.ticket});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Menjalankan animasi confetti selama 3 detik begitu halaman dibuka
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Watermark pattern rumah di bagian bawah layar
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

          // 2. Konten Utama Pembayaran Sukses
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lingkaran Centang Hijau Bersih (Tanpa emotikon samping)
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF334227), // Hijau army pekat
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Teks Judul Status
                    const Text(
                      'Pembayaran Berhasil!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222B18),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Teks Deskripsi Informasi
                    const Text(
                      'Tiket Anda telah berhasil dibeli.\nSilahkan tunjukkan QR saat memasuki area.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6B6B),
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Kartu Rincian Data Tiket
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFEBEBEB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.confirmation_num_outlined,
                            label: 'Kode Tiket',
                            value: widget.ticket.ticketCode,
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Nama Pengunjung',
                            value: widget.ticket.visitorName,
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Tanggal Kunjungan',
                            value: widget.ticket.visitDate,
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            icon: Icons.access_time_rounded,
                            label: 'Waktu Kunjungan',
                            value: widget.ticket.visitTime,
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            icon: Icons.grid_view_rounded,
                            label: 'Kategori Pengunjung',
                            value: widget.ticket.category,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol Aksi: Buka Layar Tiket Saya
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          // Berpindah ke layar tiket aktif & riwayat tiket
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyTicketsPage(vm: widget.vm),
                            ),
                          );
                        },
                        child: const Text(
                          'Lihat Tiket',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),

          // 3. Efek Animasi Hujan Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Mengarah jatuh ke bawah
              maxBlastForce: 8,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              gravity: 0.2,
              colors: const [
                Color(0xFF5B7843),
                Color(0xFF334227),
                Color(0xFFFFB800),
                Colors.orange,
                Colors.lightGreen,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Komponen baris detail rincian tiket
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: const Color(0xFF2E2E2E)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
