import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class PaymentLoadingDialog extends StatelessWidget {
  final VoidCallback onCheckStatus;

  const PaymentLoadingDialog({super.key, required this.onCheckStatus});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Loading Spinner Hijau Tua
            const SizedBox(
              width: 46,
              height: 46,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF334227)),
                backgroundColor: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 20),

            // Judul Modal
            const Text(
              'Menunggu Pembayaran',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 8),

            // Teks Keterangan
            const Text(
              'Kami sedang memverifikasi pembayaran\nAnda. Mohon tunggu beberapa saat....',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B6B6B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Cek Status
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onCheckStatus,
                child: const Text(
                  'Cek Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
