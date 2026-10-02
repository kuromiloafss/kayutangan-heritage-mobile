import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/colors.dart';
import '../../core/localization/app_language.dart';
import '../category/place_detail_page.dart';

class PlacePOI {
  final String id;
  final String title;
  final String categoryKey;
  final LatLng position;
  final String imageUrl;
  final Color pinColor;
  final IconData icon;

  const PlacePOI({
    required this.id,
    required this.title,
    required this.categoryKey,
    required this.position,
    required this.imageUrl,
    required this.pinColor,
    required this.icon,
  });
}

class TourMapPage extends StatefulWidget {
  const TourMapPage({super.key});

  @override
  State<TourMapPage> createState() => _TourMapPageState();
}

class _TourMapPageState extends State<TourMapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  final LatLng _kayutanganCenter = const LatLng(-7.9785, 112.6305);
  LatLng _userPosition = const LatLng(-7.9788, 112.6310);

  String _selectedCategoryKey = 'all';
  PlacePOI? _selectedPlace;

  StreamSubscription<Position>? _positionStreamSub;
  Timer? _simulationTimer;
  int _simStep = 0;

  // 8 Kategori Sesuai Gambar
  final List<String> _categoryKeys = const [
    'all',
    'photo_spot',
    'culinary',
    'cafe',
    'souvenir',
    'history',
    'toilet',
    'mosque',
    'lodging',
  ];

  final List<PlacePOI> _allPlaces = const [
    PlacePOI(
      id: '1',
      title: 'Jembatan dan Kanal Kayutangan',
      categoryKey: 'photo_spot',
      position: LatLng(-7.9792, 112.6312),
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=300&auto=format&fit=crop',
      pinColor: Color(0xFFC87055),
      icon: Icons.camera_alt_rounded,
    ),
    PlacePOI(
      id: '2',
      title: 'Spot Sepeda Onthel Antik',
      categoryKey: 'photo_spot',
      position: LatLng(-7.9780, 112.6318),
      imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=300&auto=format&fit=crop',
      pinColor: Color(0xFFC87055),
      icon: Icons.camera_alt_rounded,
    ),
    PlacePOI(
      id: '3',
      title: 'Warung Nasi Buk & Rawon Kayutangan',
      categoryKey: 'culinary',
      position: LatLng(-7.9789, 112.6302),
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=300&auto=format&fit=crop',
      pinColor: Color(0xFFE53935),
      icon: Icons.restaurant_rounded,
    ),
    PlacePOI(
      id: '4',
      title: 'Calathea Garden Kafe',
      categoryKey: 'cafe',
      position: LatLng(-7.9776, 112.6298),
      imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=300&auto=format&fit=crop',
      pinColor: Color(0xFFE89A3C),
      icon: Icons.local_cafe_rounded,
    ),
    PlacePOI(
      id: '5',
      title: 'Kopi Lonceng Kayutangan',
      categoryKey: 'cafe',
      position: LatLng(-7.9783, 112.6314),
      imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=300&auto=format&fit=crop',
      pinColor: Color(0xFFE89A3C),
      icon: Icons.local_cafe_rounded,
    ),
    PlacePOI(
      id: '6',
      title: 'Galeri Batik & Souvenir Kayutangan',
      categoryKey: 'souvenir',
      position: LatLng(-7.9786, 112.6315),
      imageUrl: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&auto=format&fit=crop',
      pinColor: Color(0xFFD81B60),
      icon: Icons.card_giftcard_rounded,
    ),
    PlacePOI(
      id: '7',
      title: 'Rumah Kolonial 1870',
      categoryKey: 'history',
      position: LatLng(-7.9781, 112.6301),
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=300&auto=format&fit=crop',
      pinColor: Color(0xFF8B5CF6),
      icon: Icons.account_balance_rounded,
    ),
    PlacePOI(
      id: '8',
      title: 'Makam Sesepuh Kyai Qoyyim',
      categoryKey: 'history',
      position: LatLng(-7.9772, 112.6309),
      imageUrl: 'https://images.unsplash.com/photo-1590076215667-875d4ef2d7ee?w=300&auto=format&fit=crop',
      pinColor: Color(0xFF8B5CF6),
      icon: Icons.museum_rounded,
    ),
    PlacePOI(
      id: '9',
      title: 'Toilet Umum Koridor 1',
      categoryKey: 'toilet',
      position: LatLng(-7.9790, 112.6307),
      imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300&auto=format&fit=crop',
      pinColor: Color(0xFF0288D1),
      icon: Icons.wc_rounded,
    ),
    PlacePOI(
      id: '10',
      title: 'Masjid Baiturrohman Kayutangan',
      categoryKey: 'mosque',
      position: LatLng(-7.9779, 112.6311),
      imageUrl: 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=300&auto=format&fit=crop',
      pinColor: Color(0xFF2E7D32),
      icon: Icons.mosque_rounded,
    ),
    PlacePOI(
      id: '11',
      title: 'Heritage Homestay Kayutangan',
      categoryKey: 'lodging',
      position: LatLng(-7.9774, 112.6294),
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300&auto=format&fit=crop',
      pinColor: Color(0xFF5D4037),
      icon: Icons.hotel_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPlace = _allPlaces.first;
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    _simulationTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _positionStreamSub = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            distanceFilter: 5,
          ),
        ).listen((pos) {
          if (mounted) {
            setState(() {
              _userPosition = LatLng(pos.latitude, pos.longitude);
            });
          }
        });
      } else {
        _startWalkSimulation();
      }
    } catch (_) {
      _startWalkSimulation();
    }
  }

  void _startWalkSimulation() {
    if (_simulationTimer != null && _simulationTimer!.isActive) return;

    final walkPath = [
      const LatLng(-7.9788, 112.6310),
      const LatLng(-7.9790, 112.6312),
      const LatLng(-7.9792, 112.6312),
      const LatLng(-7.9784, 112.6304),
      const LatLng(-7.9781, 112.6301),
      const LatLng(-7.9776, 112.6298),
    ];

    _simulationTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        _simStep = (_simStep + 1) % walkPath.length;
        _userPosition = walkPath[_simStep];
      });
    });
  }

  int _calculateDistance(LatLng target) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, _userPosition, target).round();
  }

  List<PlacePOI> get _filteredPlaces {
    final query = _searchController.text.trim().toLowerCase();
    return _allPlaces.where((p) {
      final matchCat =
          _selectedCategoryKey == 'all' || p.categoryKey == _selectedCategoryKey;
      final matchQuery = query.isEmpty || p.title.toLowerCase().contains(query);
      return matchCat && matchQuery;
    }).toList();
  }

  IconData _getCategoryIcon(String key) {
    switch (key) {
      case 'photo_spot':
        return Icons.camera_alt_outlined;
      case 'culinary':
        return Icons.restaurant_outlined;
      case 'cafe':
        return Icons.local_cafe_outlined;
      case 'souvenir':
        return Icons.card_giftcard_outlined;
      case 'history':
        return Icons.account_balance_outlined;
      case 'toilet':
        return Icons.wc_outlined;
      case 'mosque':
        return Icons.mosque_outlined;
      case 'lodging':
        return Icons.hotel_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  void _openAIAssistantDialog() {
    final isId = AppLanguage.isIndonesian;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFE89A3C), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    isId ? 'AI Tour Guide Kayutangan' : 'Kayutangan AI Tour Guide',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isId
                    ? 'AI mendeteksi lokasi real-time Anda di gang heritage. Berikut rute santai terbaik:'
                    : 'AI detected your real-time position near heritage alleys. Here is your best relaxed route:',
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8F4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE0E8DA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isId ? '💡 Saran Langkah AI:' : '💡 AI Suggested Route:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2C391E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isId
                          ? '1. Jembatan & Kanal Kayutangan (${_calculateDistance(const LatLng(-7.9792, 112.6312))}m) - Spot foto terbaik saat sore.\n'
                            '2. Rumah Kolonial 1870 untuk wisata Sejarah.\n'
                            '3. Santap sore di Calathea Garden Kafe atau Kopi Lonceng.'
                          : '1. Kayutangan Bridge & Canal (${_calculateDistance(const LatLng(-7.9792, 112.6312))}m) - Best photo spot.\n'
                            '2. Colonial House 1870 for Historical exploration.\n'
                            '3. Relax at Calathea Garden Cafe or Kopi Lonceng.',
                      style: const TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _mapController.move(const LatLng(-7.9792, 112.6312), 17.8);
                    setState(() => _selectedPlace = _allPlaces.first);
                  },
                  icon: const Icon(Icons.navigation_rounded, color: Colors.white, size: 18),
                  label: Text(
                    isId ? 'Pandu Saya ke Rute Ini' : 'Guide Me Along This Route',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPlaces;

    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // 1. ENGINE PETA STABIL & RINGAN (OSM TILE)
              RepaintBoundary(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _kayutanganCenter,
                    initialZoom: 17.5,
                    minZoom: 14.5,
                    maxZoom: 18.5,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.kayutangan.heritage',
                      keepBuffer: 1,
                      maxZoom: 19,
                    ),
                    MarkerLayer(
                      markers: [
                        // User GPS Marker
                        Marker(
                          point: _userPosition,
                          width: 90,
                          height: 50,
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B7F53),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  AppLanguage.tr('you_are_here'),
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // POI Markers
                        ...filtered.map((place) {
                          final isSelected = _selectedPlace?.id == place.id;
                          return Marker(
                            point: place.position,
                            width: isSelected ? 46 : 38,
                            height: isSelected ? 46 : 38,
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedPlace = place);
                                _mapController.move(place.position, 17.8);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF334227) : place.pinColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Icon(
                                  place.icon,
                                  color: Colors.white,
                                  size: isSelected ? 22 : 18,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. SEARCH BAR & 8 KATEGORI
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Color(0xFF2E2E2E), size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: AppLanguage.tr('search_place_hint'),
                                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF757575)),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {});
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categoryKeys.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final catKey = _categoryKeys[index];
                            final isSel = _selectedCategoryKey == catKey;
                            return FilterChip(
                              avatar: catKey != 'all'
                                  ? Icon(
                                      _getCategoryIcon(catKey),
                                      size: 14,
                                      color: isSel ? Colors.white : const Color(0xFF555555),
                                    )
                                  : null,
                              label: Text(AppLanguage.tr(catKey)),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : const Color(0xFF444444),
                              ),
                              selected: isSel,
                              selectedColor: AppColors.primary,
                              backgroundColor: Colors.white,
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: isSel ? AppColors.primary : Colors.grey.shade300),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategoryKey = catKey;
                                  final available = _filteredPlaces;
                                  if (available.isNotEmpty && !available.contains(_selectedPlace)) {
                                    _selectedPlace = available.first;
                                  } else if (available.isEmpty) {
                                    _selectedPlace = null;
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. TANYA AI & RE-CENTER TOMBOL
              Positioned(
                right: 16,
                bottom: _selectedPlace != null ? 140 : 30,
                child: Column(
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'ai_btn',
                      backgroundColor: const Color(0xFF2E3D22),
                      onPressed: _openAIAssistantDialog,
                      icon: const Icon(Icons.auto_awesome, color: Color(0xFFFFD54F), size: 20),
                      label: Text(
                        AppLanguage.tr('ask_ai'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton.small(
                      heroTag: 'gps_btn',
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _mapController.move(_userPosition, 17.8);
                      },
                      child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              // 4. FLOATING BOTTOM CARD DETAIL
              if (_selectedPlace != null)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailPage(
                            title: _selectedPlace!.title,
                            category: AppLanguage.tr(_selectedPlace!.categoryKey),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              _selectedPlace!.imageUrl,
                              width: 74,
                              height: 74,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 74,
                                height: 74,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedPlace!.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E1E),
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF7ED),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFFFFEDD5)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(_selectedPlace!.icon, size: 12, color: const Color(0xFFC2410C)),
                                          const SizedBox(width: 4),
                                          Text(
                                            AppLanguage.tr(_selectedPlace!.categoryKey),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFC2410C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF888888)),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${_calculateDistance(_selectedPlace!.position)} m',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF666666),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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