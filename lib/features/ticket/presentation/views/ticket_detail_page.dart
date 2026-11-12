import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/assets.dart';
import '../viewmodels/ticket_view_model.dart';

class TicketDetailPage extends StatefulWidget {
  final TicketViewModel vm;
  final String ticketCode;

  const TicketDetailPage({
    super.key,
    required this.vm,
    required this.ticketCode,
  });

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.vm.ambilDetailTiket(widget.ticketCode);
  }

  void _handleScanTicket() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Masuk Area'),
        content: const Text(
          'Simulasikan scan QR code petugas? Status tiket akan berubah menjadi "Sudah Digunakan" dan dipindahkan ke Riwayat Tiket.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final scanned = widget.vm.tandaiTiketDigunakan(widget.ticketCode);
              Navigator.pop(ctx);
              if (!scanned) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.vm.pesanError ?? ''),
                    backgroundColor: Colors.red.shade700,
                  ),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Tiket berhasil di-scan! Tiket dipindahkan ke Riwayat Tiket.',
                  ),
                  backgroundColor: Color(0xFF334227),
                ),
              );
            },
            child: const Text(
              'Scan Sekarang',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) {
        final ticket = widget.vm.tiketDetail;
        if (ticket == null) {
          return Scaffold(
            body: Center(
              child: Text(widget.vm.pesanError ?? 'Tiket tidak tersedia'),
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
              'Detail Tiket',
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

              // 2. Konten Detail Tiket
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kartu Utama Tiket Wisata
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header Hijau Army
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF334227),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.confirmation_num_outlined,
                                      color: Color(0xFF334227),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Akses Tiket Wisata',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Kampoeng Heritage Kayutangan',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Badge Status Tiket
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ticket.isActive
                                          ? const Color(0xFF758A60)
                                          : const Color(0xFF888888),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          ticket.isActive
                                              ? Icons.check
                                              : Icons.history,
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          ticket.isActive
                                              ? 'Tiket Aktif'
                                              : 'Sudah Dipakai',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Bagian QR & Rincian Kunjungan
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(22),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFEEEEEE),
                                ),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Sisi Kiri: Kotak QR Code
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: ticket.isActive
                                                ? _handleScanTicket
                                                : null,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE0E0E0,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.qr_code_2_rounded,
                                                size: 110,
                                                color: ticket.isActive
                                                    ? const Color(0xFF222222)
                                                    : Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            ticket.isActive
                                                ? 'Tunjukkan QR Kode\nsaat memasuki area'
                                                : 'QR Tiket ini telah\nselesai digunakan',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: ticket.isActive
                                                  ? const Color(0xFF757575)
                                                  : Colors.grey,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Garis Vertikal Pemisah Putus-Putus
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: CustomPaint(
                                        painter: DashedLinePainter(),
                                      ),
                                    ),

                                    // Sisi Kanan: Tanggal, Waktu & Lokasi
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            _buildInfoSection(
                                              icon:
                                                  Icons.calendar_today_outlined,
                                              title: 'Tanggal Kunjungan',
                                              detail: ticket.visitTime,
                                            ),
                                            const SizedBox(height: 12),
                                            _buildInfoSection(
                                              icon: Icons.access_time_rounded,
                                              title: 'Waktu Kunjungan',
                                              detail: ticket.visitDate,
                                            ),
                                            const SizedBox(height: 12),
                                            _buildInfoSection(
                                              icon: Icons.location_on_outlined,
                                              title: 'Lokasi',
                                              detail: ticket.location,
                                              subDetail: ticket.subLocation,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Kartu Info Pengunjung & Kode Tiket
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
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
                          children: [
                            _buildUserRow(
                              icon: Icons.confirmation_num_outlined,
                              title: 'Kode Tiket',
                              value: ticket.ticketCode,
                            ),
                            const Divider(height: 22, color: Color(0xFFF0F0F0)),
                            _buildUserRow(
                              icon: Icons.person_outline_rounded,
                              title: 'Nama Pengunjung',
                              value: ticket.visitorName,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tombol "Lihat Lokasi"
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            debugPrint('Membuka rute ke ${ticket.location}');
                          },
                          leading: const Icon(
                            Icons.map_outlined,
                            color: Color(0xFF2E2E2E),
                            size: 24,
                          ),
                          title: const Text(
                            'Lihat Lokasi',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF222222),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF888888),
                            size: 24,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tombol Simulasi Scan Masuk Area (Hanya jika tiket aktif)
                      if (ticket.isActive)
                        SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _handleScanTicket,
                            icon: const Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 20,
                            ),
                            label: const Text(
                              'Simulasi Scan Petugas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 90),
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

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String detail,
    String? subDetail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF334227)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 1),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              if (subDetail != null)
                Text(
                  subDetail,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888888),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF444444), size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Garis Putus-Putus Vertikal
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashHeight = 4, dashSpace = 4;
    double startY = 0;
    final paint = Paint()
      ..color = const Color(0xFFD6D6D6)
      ..strokeWidth = 1.2;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
