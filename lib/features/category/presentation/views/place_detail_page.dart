import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../viewmodels/place_detail_view_model.dart';

class PlaceDetailPage extends StatefulWidget {
  final PlaceDetailViewModel vm;
  final String placeId;
  final String? categoryTitle;

  const PlaceDetailPage({
    super.key,
    required this.vm,
    required this.placeId,
    this.categoryTitle,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  int _activeImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    widget.vm.ambilDetail(widget.placeId, categoryTitle: widget.categoryTitle);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Bottom Sheet untuk Input Ulasan Baru
  void _openAddReviewSheet() {
    double selectedRating = 5.0;
    final nameController = TextEditingController();
    final commentController = TextEditingController();

    showModalBottomSheet<void>(
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
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
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
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
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
                          final added = widget.vm.tambahUlasan(
                            userName: nameController.text,
                            rating: selectedRating,
                            comment: commentController.text,
                          );
                          if (!added) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(widget.vm.pesanError ?? ''),
                                backgroundColor: Colors.red.shade700,
                              ),
                            );
                            return;
                          }
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
    ).whenComplete(() {
      nameController.dispose();
      commentController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm,
      builder: (context, _) {
        final place = widget.vm.place;
        if (place == null) {
          return Scaffold(
            body: Center(
              child: Text(widget.vm.pesanError ?? 'Tempat tidak tersedia'),
            ),
          );
        }
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
                  itemCount: place.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _activeImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      place.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2. Tombol Back
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
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
                          place.images.length,
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
                                place.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Subkategori
                              Text(
                                widget.vm.categoryOverride ??
                                    place.categoryName,
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
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFB800),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.vm.averageRating}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${widget.vm.reviews.length} ulasan)',
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
                                place.description,
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
                                place.operationalHours,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF616161),
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 22),

                              // 4. GALERI FOTO PENGUNJUNG
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    '${place.galleryImages.length} Foto',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8D7B68),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              SizedBox(
                                height: 85,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: place.galleryImages.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        place.galleryImages[index],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    icon: const Icon(
                                      Icons.add_comment_outlined,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'Beri Ulasan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Daftar Review Cards
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.vm.reviews.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final rev = widget.vm.reviews[index];
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFEEEEEE),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
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
      },
    );
  }
}
