import 'package:flutter/material.dart';
import '../../../core/constants/assets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo Kajoetangan Heritage
        Image.asset(
          AppAssets.logoDashboard,
          height: 38,
          fit: BoxFit.contain,
        ),

        // Profil Avatar Bulat
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            color: Colors.white,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.person, color: Color(0xFF424242), size: 24),
            onPressed: () {
              // Aksi navigasi ke profil
            },
          ),
        ),
      ],
    );
  }
}