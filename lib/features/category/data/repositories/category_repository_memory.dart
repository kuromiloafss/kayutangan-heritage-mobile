import '../../domain/entities/kategori.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryMemory implements CategoryRepository {
  static const _detailDescription =
      'Berbeda dengan kebanyakan kafe yang dirancang sejak awal, Calathea Garden justru tumbuh alami dari lingkungan sekitar yang sudah asri. Umay, sebagai staf Calathea, menjelaskan bahwa konsep kafe yang hadir karena taman yang sudah ada sejak awal, sudah tertata indah dan dimanfaatkan sebagai kafe.';
  static const _operationalHours =
      'Senin – Kamis: 09.00 – 22.00\nJumat – Minggu: 08.00 – 22.00 / 08.00 – 10.00 malam';
  static const _detailImages = [
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1559925393-8be0ec4767c8?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=800&auto=format&fit=crop',
  ];
  static const _galleryImages = [
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=500&auto=format&fit=crop',
  ];

  final List<Kategori> _categories = const [
    Kategori(id: 'photo_spot', title: 'Spot Foto', emoji: '📸'),
    Kategori(id: 'culinary', title: 'Kuliner', emoji: '🍜'),
    Kategori(id: 'cafe', title: 'Cafe', emoji: '☕'),
    Kategori(id: 'souvenir', title: 'Cinderamata', emoji: '🎁'),
    Kategori(id: 'history', title: 'Sejarah', emoji: '🏛️'),
    Kategori(id: 'toilet', title: 'Toilet', emoji: '🚻'),
    Kategori(id: 'mosque', title: 'Mesjid', emoji: '🕌'),
    Kategori(id: 'lodging', title: 'Penginapan', emoji: '🏨'),
    Kategori(
      id: 'reviews',
      title: 'Ulasan',
      emoji: '🌟',
      tampilDiBeranda: false,
    ),
  ];

  final List<Place> _data = const [
    Place(
      id: 'bougenvile',
      title: 'Bougenvile',
      categoryKey: 'photo_spot',
      categoryName: 'Spot Foto',
      description: 'Keindahan bunga Bougenville yang menghiasi sudut Kampung Heritage Kayutangan, cocok untuk bersantai dan berfoto.',
      imagePath: 'https://images.unsplash.com/photo-1596726978553-6252bfd59187?w=600&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
    ),
    Place(
      id: 'sepeda_ontel',
      title: 'Sepeda ontel',
      categoryKey: 'photo_spot',
      categoryName: 'Spot Foto',
      description: 'Tidak jauh dari spot pintu dan jendela tua tadi, terdapat area properti sepeda ontel dan kursi zaman dahulu.',
      imagePath: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=600&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
    ),
    Place(
      id: 'tulisan_kampoeng_kajoetangan',
      title: 'Tulisan Kampoeng Kajoetangan',
      categoryKey: 'photo_spot',
      categoryName: 'Spot Foto',
      description: 'Spot mural dan tulisan ikonik dinding bata putih yang menjadi ciri khas penanda kawasan cagar budaya.',
      imagePath: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
    ),
    Place(
      id: '1',
      title: 'Jembatan dan Kanal Kayutangan',
      categoryKey: 'photo_spot',
      categoryName: 'Spot Foto',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9792,
      longitude: 112.6312,
      pinColor: 0xFFC87055,
      markerIconKey: 'photo_spot',
    ),
    Place(
      id: '2',
      title: 'Spot Sepeda Onthel Antik',
      categoryKey: 'photo_spot',
      categoryName: 'Spot Foto',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9780,
      longitude: 112.6318,
      pinColor: 0xFFC87055,
      markerIconKey: 'photo_spot',
    ),
    Place(
      id: '3',
      title: 'Warung Nasi Buk & Rawon Kayutangan',
      categoryKey: 'culinary',
      categoryName: 'Kuliner',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9789,
      longitude: 112.6302,
      pinColor: 0xFFE53935,
      markerIconKey: 'culinary',
    ),
    Place(
      id: '4',
      title: 'Calathea Garden Kafe',
      categoryKey: 'cafe',
      categoryName: 'Cafe',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9776,
      longitude: 112.6298,
      pinColor: 0xFFE89A3C,
      markerIconKey: 'cafe',
    ),
    Place(
      id: '5',
      title: 'Kopi Lonceng Kayutangan',
      categoryKey: 'cafe',
      categoryName: 'Cafe',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9783,
      longitude: 112.6314,
      pinColor: 0xFFE89A3C,
      markerIconKey: 'cafe',
    ),
    Place(
      id: '6',
      title: 'Galeri Batik & Souvenir Kayutangan',
      categoryKey: 'souvenir',
      categoryName: 'Cinderamata',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9786,
      longitude: 112.6315,
      pinColor: 0xFFD81B60,
      markerIconKey: 'souvenir',
    ),
    Place(
      id: '7',
      title: 'Rumah Kolonial 1870',
      categoryKey: 'history',
      categoryName: 'Sejarah',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9781,
      longitude: 112.6301,
      pinColor: 0xFF8B5CF6,
      markerIconKey: 'history',
    ),
    Place(
      id: '8',
      title: 'Makam Sesepuh Kyai Qoyyim',
      categoryKey: 'history',
      categoryName: 'Sejarah',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1590076215667-875d4ef2d7ee?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9772,
      longitude: 112.6309,
      pinColor: 0xFF8B5CF6,
      markerIconKey: 'museum',
    ),
    Place(
      id: '9',
      title: 'Toilet Umum Koridor 1',
      categoryKey: 'toilet',
      categoryName: 'Toilet',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9790,
      longitude: 112.6307,
      pinColor: 0xFF0288D1,
      markerIconKey: 'toilet',
    ),
    Place(
      id: '10',
      title: 'Masjid Baiturrohman Kayutangan',
      categoryKey: 'mosque',
      categoryName: 'Mesjid',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9779,
      longitude: 112.6311,
      pinColor: 0xFF2E7D32,
      markerIconKey: 'mosque',
    ),
    Place(
      id: '11',
      title: 'Heritage Homestay Kayutangan',
      categoryKey: 'lodging',
      categoryName: 'Penginapan',
      description: _detailDescription,
      imagePath: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300&auto=format&fit=crop',
      isNetwork: true,
      initialRating: 4.8,
      operationalHours: _operationalHours,
      images: _detailImages,
      galleryImages: _galleryImages,
      latitude: -7.9774,
      longitude: 112.6294,
      pinColor: 0xFF5D4037,
      markerIconKey: 'lodging',
    ),
  ];

  static const List<Review> _initialReviews = [
    Review(
      userName: 'Ahmad Fauzi',
      rating: 5.0,
      date: '2 hari lalu',
      comment: 'Tempatnya teduh banget, banyak spot foto vintage yang estetik dan instagramable!',
    ),
    Review(
      userName: 'Siti Rahma',
      rating: 4.5,
      date: '1 minggu lalu',
      comment: 'Kopi dan suasananya enak buat santai sore setelah jalan keliling Kayutangan.',
    ),
  ];

  final Map<String, List<Review>> _reviews = {};

  @override
  List<Kategori> getCategories({bool homeOnly = false}) {
    final categories = homeOnly
        ? _categories.where((category) => category.tampilDiBeranda)
        : _categories;
    return List.unmodifiable(categories);
  }

  @override
  List<Place> getPlacesByCategory(String categoryTitle) {
    return List.unmodifiable(_data.take(3));
  }

  @override
  List<Place> getTourPlaces() {
    return List.unmodifiable(_data.where((place) => place.latitude != null));
  }

  @override
  Place? getPlaceById(String placeId) {
    for (final place in _data) {
      if (place.id == placeId) return place;
    }
    return null;
  }

  @override
  List<Review> getReviews(String placeId) {
    return List.unmodifiable(_reviews[placeId] ?? _initialReviews);
  }

  @override
  void addReview(String placeId, Review review) {
    final placeReviews = List<Review>.from(
      _reviews[placeId] ?? _initialReviews,
    );
    placeReviews.insert(0, review);
    _reviews[placeId] = placeReviews;
  }
}
