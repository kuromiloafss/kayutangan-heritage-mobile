import 'package:flutter/material.dart';

class MapAccessCard extends StatelessWidget {
  final VoidCallback onTap;

  const MapAccessCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF354428), // Hijau army tua pekat
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Ikon Tiket Bulat Putih
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.confirmation_num_outlined,
                color: Color(0xFF354428),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Teks Keterangan
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buka Akses Peta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Beli tiket dulu untuk mengakses peta real-time',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Panah Kanan
            const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF5B7843),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}