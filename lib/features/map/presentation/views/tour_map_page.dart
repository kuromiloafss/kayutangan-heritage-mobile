import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/localization/app_language.dart';
import '../../../category/domain/entities/place.dart';
import '../../../category/presentation/views/place_detail_page.dart';
import '../../../category/presentation/viewmodels/place_detail_view_model.dart';
import '../../domain/entities/geo_point.dart';
import '../viewmodels/map_view_model.dart';

class TourMapPage extends StatefulWidget {
  final PlaceDetailViewModel placeDetailViewModel;
  final MapViewModel mapViewModel;

  const TourMapPage({
    super.key,
    required this.placeDetailViewModel,
    required this.mapViewModel,
  });

  @override
  State<TourMapPage> createState() => _TourMapPageState();
}

class _TourMapPageState extends State<TourMapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  String? _lastShownError;

  @override
  void initState() {
    super.initState();
    widget.mapViewModel.addListener(_showMapError);
    widget.mapViewModel.startLocationTracking();
  }

  @override
  void dispose() {
    widget.mapViewModel.removeListener(_showMapError);
    widget.mapViewModel.stopLocationTracking();
    _searchController.dispose();
    super.dispose();
  }

  void _showMapError() {
    final error = widget.mapViewModel.pesanError;
    if (error == null) {
      _lastShownError = null;
      return;
    }
    if (error == _lastShownError) return;
    _lastShownError = error;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    });
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

  IconData _getPlaceIcon(Place place) {
    switch (place.markerIconKey ?? place.categoryKey) {
      case 'photo_spot':
        return Icons.camera_alt_rounded;
      case 'culinary':
        return Icons.restaurant_rounded;
      case 'cafe':
        return Icons.local_cafe_rounded;
      case 'souvenir':
        return Icons.card_giftcard_rounded;
      case 'history':
        return Icons.account_balance_rounded;
      case 'museum':
        return Icons.museum_rounded;
      case 'toilet':
        return Icons.wc_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'lodging':
        return Icons.hotel_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  LatLng _toLatLng(GeoPoint point) => LatLng(point.latitude, point.longitude);

  LatLng _placePosition(Place place) =>
      LatLng(place.latitude!, place.longitude!);

  void _openAIAssistantDialog() {
    final isId = AppLanguage.isIndonesian;
    final suggestedPlace = widget.mapViewModel.places.isEmpty
        ? null
        : widget.mapViewModel.places.first;
    final suggestedDistance = suggestedPlace == null
        ? 0
        : widget.mapViewModel.calculateDistance(suggestedPlace);
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
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFE89A3C),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isId
                        ? 'AI Tour Guide Kayutangan'
                        : 'Kayutangan AI Tour Guide',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                          ? '1. Jembatan & Kanal Kayutangan (${suggestedDistance}m) - Spot foto terbaik saat sore.\n'
                                '2. Rumah Kolonial 1870 untuk wisata Sejarah.\n'
                                '3. Santap sore di Calathea Garden Kafe atau Kopi Lonceng.'
                          : '1. Kayutangan Bridge & Canal (${suggestedDistance}m) - Best photo spot.\n'
                                '2. Colonial House 1870 for Historical exploration.\n'
                                '3. Relax at Calathea Garden Cafe or Kopi Lonceng.',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: Color(0xFF333333),
                      ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (suggestedPlace != null) {
                      _mapController.move(_placePosition(suggestedPlace), 17.8);
                      widget.mapViewModel.selectSuggestedRoute();
                    }
                  },
                  icon: const Icon(
                    Icons.navigation_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    isId
                        ? 'Pandu Saya ke Rute Ini'
                        : 'Guide Me Along This Route',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, _, __) {
        return ListenableBuilder(
          listenable: widget.mapViewModel,
          builder: (context, _) {
            final viewModel = widget.mapViewModel;
            final route = viewModel.route;
            final userPosition = viewModel.userPosition;
            final selectedPlace = viewModel.selectedPlace;
            if (route == null || userPosition == null) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Text(
                    viewModel.pesanError ?? 'Peta tidak dapat dimuat',
                  ),
                ),
              );
            }

            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  // 1. ENGINE PETA STABIL & RINGAN (OSM TILE)
                  RepaintBoundary(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _toLatLng(route.mapCenter),
                        initialZoom: 17.5,
                        minZoom: 14.5,
                        maxZoom: 18.5,
                        interactionOptions: const InteractionOptions(
                          flags:
                              InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.kayutangan.heritage',
                          keepBuffer: 1,
                          maxZoom: 19,
                        ),
                        MarkerLayer(
                          markers: [
                            // User GPS Marker
                            Marker(
                              point: _toLatLng(userPosition),
                              width: 90,
                              height: 50,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6B7F53),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      AppLanguage.tr('you_are_here'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2563EB),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // POI Markers
                            ...widget.mapViewModel.filteredPlaces.map((place) {
                              final isSelected = selectedPlace?.id == place.id;
                              return Marker(
                                point: _placePosition(place),
                                width: isSelected ? 46 : 38,
                                height: isSelected ? 46 : 38,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.mapViewModel.selectPlace(place);
                                    _mapController.move(
                                      _placePosition(place),
                                      17.8,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF334227)
                                          : Color(place.pinColor ?? 0xFF334227),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _getPlaceIcon(place),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF2E2E2E),
                                    size: 20,
                                  ),
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
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged:
                                        widget.mapViewModel.setSearchQuery,
                                    style: const TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: AppLanguage.tr(
                                        'search_place_hint',
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF888888),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Color(0xFF757575),
                                      ),
                                      suffixIcon:
                                          _searchController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                _searchController.clear();
                                                widget.mapViewModel
                                                    .setSearchQuery('');
                                              },
                                            )
                                          : null,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
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
                              itemCount:
                                  widget.mapViewModel.categoryKeys.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final catKey =
                                    widget.mapViewModel.categoryKeys[index];
                                final isSel =
                                    widget.mapViewModel.selectedCategoryKey ==
                                    catKey;
                                return FilterChip(
                                  avatar: catKey != 'all'
                                      ? Icon(
                                          _getCategoryIcon(catKey),
                                          size: 14,
                                          color: isSel
                                              ? Colors.white
                                              : const Color(0xFF555555),
                                        )
                                      : null,
                                  label: Text(AppLanguage.tr(catKey)),
                                  labelStyle: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSel
                                        ? Colors.white
                                        : const Color(0xFF444444),
                                  ),
                                  selected: isSel,
                                  selectedColor: AppColors.primary,
                                  backgroundColor: Colors.white,
                                  checkmarkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: isSel
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  onSelected: (selected) {
                                    widget.mapViewModel.selectCategory(catKey);
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
                    bottom: widget.mapViewModel.selectedPlace != null
                        ? 140
                        : 30,
                    child: Column(
                      children: [
                        FloatingActionButton.extended(
                          heroTag: 'ai_btn',
                          backgroundColor: const Color(0xFF2E3D22),
                          onPressed: _openAIAssistantDialog,
                          icon: const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFFFD54F),
                            size: 20,
                          ),
                          label: Text(
                            AppLanguage.tr('ask_ai'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FloatingActionButton.small(
                          heroTag: 'gps_btn',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            final position = widget.mapViewModel.userPosition;
                            if (position != null) {
                              _mapController.move(_toLatLng(position), 17.8);
                            }
                          },
                          child: const Icon(
                            Icons.my_location_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. FLOATING BOTTOM CARD DETAIL
                  if (selectedPlace != null)
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
                                vm: widget.placeDetailViewModel,
                                placeId: selectedPlace.id,
                                categoryTitle: AppLanguage.tr(
                                  selectedPlace.categoryKey,
                                ),
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
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  selectedPlace.imagePath,
                                  width: 74,
                                  height: 74,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 74,
                                    height: 74,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedPlace.title,
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF7ED),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFFFEDD5),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _getPlaceIcon(selectedPlace),
                                                size: 12,
                                                color: const Color(0xFFC2410C),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                AppLanguage.tr(
                                                  selectedPlace.categoryKey,
                                                ),
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
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: Color(0xFF888888),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${widget.mapViewModel.calculateDistance(selectedPlace)} m',
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
      },
    );
  }
}
