import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/assets.dart';
import 'components/payment_loading_dialog.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  final int totalPrice;

  const PaymentPage({
    super.key,
    this.totalPrice = 5000,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Waktu hitung mundur 10 menit (600 detik)
  int _remainingSeconds = 600;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Membuka modal loading otomatis setelah 2 detik simulasi scan QR
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showPaymentLoadingModal();
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _showTimeExpiredDialog();
      }
    });
  }

  void _showPaymentLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (ctx) => PaymentLoadingDialog(
        onCheckStatus: () {
          Navigator.pop(ctx); // Tutup dialog loading
          // Berpindah ke halaman sukses pembayaran dengan efek confetti
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentSuccessPage(),
            ),
          );
        },
      ),
    );
  }

  void _showTimeExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Waktu Pembayaran Habis'),
        content: const Text(
          'Pesanan telah dibatalkan otomatis. Silakan lakukan pemesanan ulang.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Oke', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _minutesText {
    return (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
  }

  String get _secondsText {
    return (_remainingSeconds % 60).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = widget.totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

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
          'Pembayaran',
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
                child: Image.asset(
                  AppAssets.pattern,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          // 2. Konten Pembayaran
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                children: [
                  // Banner Countdown Timer (Hijau Muda Lembut)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EFE3),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 48,
                          color: Color(0xFF2C391E),
                        ),
                        const SizedBox(width: 18),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selesaikan pembayaran dalam',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF555555),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_minutesText : $_secondsText',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222),
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Row(
                              children: [
                                Text(
                                  'Menit',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B)),
                                ),
                                SizedBox(width: 32),
                                Text(
                                  'Detik',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF6B6B6B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Kartu Utama Pembayaran & QRIS
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Baris Header Kartu: Total Pembayaran & Nominal
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              Text(
                                'Rp $formattedPrice',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),

                        Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Column(
                            children: [
                              // Teks Petunjuk Scan
                              const Text(
                                'Silahkan scan QR code berikut menggunakan\naplikasi e-wallet atau mobile banking.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF555555),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Kotak QR Code Interaktif
                              GestureDetector(
                                onTap: _showPaymentLoadingModal,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE2E2E2)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 150,
                                        color: Color(0xFF1F2B14),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'QRIS',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2.0,
                                          color: Color(0xFF1F2B14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Teks Peringatan Batas Waktu
                              const Text(
                                'Jika waktu habis, pesanan akan dibatalkan dan\nAnda perlu melakukan pemesanan ulang.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9E9E9E),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}