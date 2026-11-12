import 'package:flutter/material.dart';

import '../../../category/domain/entities/kategori.dart';

class CategoryGrid extends StatelessWidget {
  final List<Kategori> categories;
  final Function(String category) onCategoryTap;
  final VoidCallback onSeeAllTap; // Parameter callback baru

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Baris Header Kategori Jelajah
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategori Jelajah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSeeAllTap, // Panggil modal pop up
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Grid 4 Kolom di Beranda
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return InkWell(
              onTap: () => onCategoryTap(item.title),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFECECEC)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
