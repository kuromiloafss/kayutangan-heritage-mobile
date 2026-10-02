import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

// Model Data Ulasan
class ReviewItem {
  final String userName;
  final double rating;
  final String date;
  final String comment;

  ReviewItem({
    required this.userName,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class PlaceDetailPage extends StatefulWidget {
  final String title;
  final String category;
  final double initialRating;
  final String description;
  final String operationalHours;
  final List<String> images;

  const PlaceDetailPage({
    super.key,
    this.title = 'Calathea Garden',
    this.category = 'Spot Foto',
    this.initialRating = 4.8,
    this.description =
        'Berbeda dengan kebanyakan kafe yang dirancang sejak awal, Calathea Garden justru tumbuh alami dari lingkungan sekitar yang sudah asri. Umay, sebagai staf Calathea, menjelaskan bahwa konsep kafe yang hadir karena taman yang sudah ada sejak awal, sudah tertata indah dan dimanfaatkan sebagai kafe.',
    this.operationalHours =
        'Senin – Kamis: 09.00 – 22.00\nJumat – Minggu: 08.00 – 22.00 / 08.00 – 10.00 malam',
    this.images = const [
      'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1559925393-8be0ec4767c8?w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=800&auto=format&fit=crop',
    ],
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  int _activeImageIndex = 0;
  final PageController _pageController = PageController();

  // State daftar ulasan
  late List<ReviewItem> _reviews;

  // Galeri foto tambahan dari tempat / pengunjung
  final List<String> _galleryImages = const [
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=500&auto=format&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _reviews = [
      ReviewItem(
        userName: 'Ahmad Fauzi',
        rating: 5.0,
        date: '2 hari lalu',
        comment: 'Tempatnya teduh banget, banyak spot foto vintage yang estetik dan instagramable!',
      ),
      ReviewItem(
        userName: 'Siti Rahma',
        rating: 4.5,
        date: '1 minggu lalu',
        comment: 'Kopi dan suasananya enak buat santai sore setelah jalan keliling Kayutangan.',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Hitung rata-rata rating dinamis
  double get _averageRating {
    if (_reviews.isEmpty) return widget.initialRating;
    final total = _reviews.fold<double>(0.0, (sum, item) => sum + item.rating);
    return double.parse((total / _reviews.length).toStringAsFixed(1));
  }

  // Bottom Sheet untuk Input Ulasan Baru
  void _openAddReviewSheet() {
    double selectedRating = 5.0;
    final nameController = TextEditingController();
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Tulis Ulasan & Rating',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bagikan pengalamanmu berkunjung ke tempat ini',
                      style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                    ),
                    const SizedBox(height: 16),

                    // Rating Star Selector
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedRating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: const Color(0xFFFFB800),
                              size: 34,
                            ),
                            onPressed: () {
                              setModalState(() {
                                selectedRating = index + 1.0;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Nama Pengulas
                    TextField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Nama kamu',
                        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Komentar
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Tulis komentar atau ulasan kamu di sini...',
                        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Kirim
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
                        onPressed: () {
                          if (nameController.text.trim().isEmpty ||
                              commentController.text.trim().isEmpty) {
                            return;
                          }

                          setState(() {
                            _reviews.insert(
                              0,
                              ReviewItem(
                                userName: nameController.text.trim(),
                                rating: selectedRating,
                                date: 'Baru saja',
                                comment: commentController.text.trim(),
                              ),
                            );
                          });

                          Navigator.pop(ctx);
                        },
                        child: const Text(
                          'Kirim Ulasan',
                          style: TextStyle(
                            fontSize: 15,
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Gambar Carousel Header
          SizedBox(
            height: screenHeight * 0.40,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _activeImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),

          // 2. Tombol Back
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.35),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 3. Panel Konten Bawah (Scrollable)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.67,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Carousel Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _activeImageIndex == index ? 16 : 6,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _activeImageIndex == index
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Detail Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul Tempat
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Subkategori
                          Text(
                            widget.category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8D7B68),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Rating Bintang & Counter Ulasan
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '$_averageRating',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${_reviews.length} ulasan)',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Deskripsi
                          const Text(
                            'Deskripsi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF616161),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Jam Operasional
                          const Text(
                            'Jam Operasional',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.operationalHours,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF616161),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 22),

                          // 4. GALERI FOTO PENGUNJUNG
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Galeri Foto',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              Text(
                                '${_galleryImages.length} Foto',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF8D7B68)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            height: 85,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _galleryImages.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    _galleryImages[index],
                                    width: 110,
                                    height: 85,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // 5. SEKSI ULASAN & TOMBOL TAMBAH
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ulasan Pengunjung',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: _openAddReviewSheet,
                                icon: const Icon(Icons.add_comment_outlined, size: 16),
                                label: const Text(
                                  'Beri Ulasan',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Daftar Review Cards
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _reviews.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final rev = _reviews[index];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFEEEEEE)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          rev.userName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF222222),
                                          ),
                                        ),
                                        Text(
                                          rev.date,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (starIndex) => Icon(
                                          starIndex < rev.rating
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          size: 15,
                                          color: const Color(0xFFFFB800),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      rev.comment,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF555555),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 28),

                          // Tombol Rute Lokasi
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
                                debugPrint("Navigasi ke Peta/Maps...");
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Buka Rute Lokasi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
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
          ),
        ],
      ),
    );
  }
}