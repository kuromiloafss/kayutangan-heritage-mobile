import 'package:flutter/material.dart';
import 'components/place_card.dart';
import 'place_detail_page.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryTitle;

  const CategoryDetailPage({
    super.key,
    this.categoryTitle = 'Spot Foto',
  });

  // Data dummy daftar tempat sesuai desain
  final List<PlaceItem> spotFotoList = const [
    PlaceItem(
      title: 'Bougenvile',
      description:
          'Keindahan bunga Bougenville yang menghiasi sudut Kampung Heritage Kayutangan, cocok untuk bersantai dan berfoto.',
      imagePath:
          'https://images.unsplash.com/photo-1596726978553-6252bfd59187?w=600&auto=format&fit=crop',
      isNetwork: true,
    ),
    PlaceItem(
      title: 'Sepeda ontel',
      description:
          'Tidak jauh dari spot pintu dan jendela tua tadi, terdapat area properti sepeda ontel dan kursi zaman dahulu.',
      imagePath:
          'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=600&auto=format&fit=crop',
      isNetwork: true,
    ),
    PlaceItem(
      title: 'Tulisan Kampoeng Kajoetangan',
      description:
          'Spot mural dan tulisan ikonik dinding bata putih yang menjadi ciri khas penanda kawasan cagar budaya.',
      imagePath:
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600&auto=format&fit=crop',
      isNetwork: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryTitle,
          style: const TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: spotFotoList.length,
        itemBuilder: (context, index) {
          final item = spotFotoList[index];
          return PlaceCard(
            item: item,
            onDetailTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailPage(
                    title: item.title,
                    category: categoryTitle,
                    description: item.description,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}