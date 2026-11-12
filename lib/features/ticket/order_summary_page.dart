import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/assets.dart';
import 'payment_page.dart';

class OrderSummaryPage extends StatelessWidget {
  final String visitorName;
  final String visitDate;
  final String visitTime;
  final String category;
  final int ticketCount;
  final int pricePerTicket;

  const OrderSummaryPage({
    super.key,
    this.visitorName = 'Budi Galaksi',
    this.visitDate = '9 September 2026',
    this.visitTime = '10.35',
    this.category = 'Lokal',
    this.ticketCount = 1,
    this.pricePerTicket = 5000,
  });

  int get totalPrice => ticketCount * pricePerTicket;

  @override
  Widget build(BuildContext context) {
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
          'Ringkasan Pesanan',
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
          // 1. Watermark Rumah di Bagian Bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  AppAssets.pattern,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          // 2. Konten Ringkasan Pesanan
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Singkat Tiket Tempat
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=200&auto=format&fit=crop',
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 65,
                            height: 65,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kampung Kayutangan\nHeritage',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tiket masuk',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8D7B68),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE5E5E5), thickness: 1),
                  const SizedBox(height: 8),

                  // Rincian Baris Data Pesanan
                  _buildSummaryRow('Nama Pengunjung', visitorName),
                  _buildSummaryRow('Tanggal Kunjungan', visitDate),
                  _buildSummaryRow('Waktu Kunjungan', visitTime),
                  _buildSummaryRow('Kategori', category),
                  _buildSummaryRow('Jumlah Tiket', '$ticketCount'),
                  _buildSummaryRow(
                    'Total Harga',
                    'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  ),

                  const SizedBox(height: 24),

                  // Metode Pembayaran
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Kartu QRIS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFECECEC)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Radio button aktif
                        const Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.radio_button_checked,
                            color: Color(0xFF2E2E2E),
                            size: 20,
                          ),
                        ),

                        // QRIS di tengah
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'QRIS',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Icon(
                                Icons.qr_code_2_rounded,
                                size: 80,
                                color: Color(0xFF334227),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Bayar dengan Qris dari aplikasi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8E8E8E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol "Bayar sekarang"
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(totalPrice: totalPrice),
                          ),
                        );
                      },
                      child: const Text(
                        'Bayar sekarang',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B6B6B),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF1F1F1), height: 1),
        ],
      ),
    );
  }
}