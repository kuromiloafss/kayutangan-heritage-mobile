import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/api_config.dart';
import '../../../category/domain/entities/place.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/tour_route.dart';
import '../../domain/usecases/ambil_rute_tour.dart';
import '../../domain/usecases/ambil_titik_tour.dart';
import '../../domain/usecases/hitung_jarak.dart';
import '../../domain/usecases/pantau_lokasi_pengguna.dart';

class MapViewModel extends ChangeNotifier {
  final AmbilTitikTour _ambilTitikTour;
  final AmbilRuteTour _ambilRuteTour;
  final HitungJarak _hitungJarak;
  final PantauLokasiPengguna _pantauLokasiPengguna;

  StreamSubscription<GeoPoint>? _positionStreamSubscription;
  Timer? _simulationTimer;
  bool _isTracking = false;
  List<Place> places = const [];
  TourRoute? route;
  GeoPoint? userPosition;
  Place? selectedPlace;
  String selectedCategoryKey = 'all';
  String searchQuery = '';
  String? pesanError;
  int _simulationStep = 0;

  // --- STATE UNTUK TANYA AI (GEMINI AI) & PANDUAN RUTE ---
  bool isLoadingAi = false;
  bool isRouteGuided = false;
  String saranLangkahAi =
      '1. Jembatan & Kanal Kayutangan - Spot foto terbaik saat sore.\n'
      '2. Rumah Kolonial 1870 untuk wisata Sejarah.\n'
      '3. Santap sore di Calathea Garden Kafe atau Kopi Lonceng.';

  MapViewModel({
    required AmbilTitikTour ambilTitikTour,
    required AmbilRuteTour ambilRuteTour,
    required HitungJarak hitungJarak,
    required PantauLokasiPengguna pantauLokasiPengguna,
  }) : _ambilTitikTour = ambilTitikTour,
       _ambilRuteTour = ambilRuteTour,
       _hitungJarak = hitungJarak,
       _pantauLokasiPengguna = pantauLokasiPengguna {
    ambilDataPeta();
  }

  List<String> get categoryKeys => [
    'all',
    ...{for (final place in places) place.categoryKey},
  ];

  List<Place> get filteredPlaces {
    final query = searchQuery.trim().toLowerCase();
    return places.where((place) {
      final matchesCategory =
          selectedCategoryKey == 'all' ||
          place.categoryKey == selectedCategoryKey;
      final matchesQuery =
          query.isEmpty || place.title.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Menghasilkan titik-titik garis rute menuju ikon tempat yang sedang dipilih (selectedPlace)
  List<GeoPoint> get activeRoutePoints {
    final start = userPosition ?? route?.initialUserPosition;
    final target = selectedPlace;

    if (start != null &&
        target != null &&
        target.latitude != null &&
        target.longitude != null) {
      return [
        start,
        GeoPoint(latitude: target.latitude!, longitude: target.longitude!),
      ];
    }
    return route?.simulationPath ?? const <GeoPoint>[];
  }

  void ambilDataPeta() {
    pesanError = null;
    try {
      places = _ambilTitikTour.execute();
      route = _ambilRuteTour.execute();
      userPosition = route?.initialUserPosition;
      selectedPlace = places.isEmpty ? null : places.first;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    _ensureSelectedPlaceIsVisible();
    notifyListeners();
  }

  void selectCategory(String categoryKey) {
    selectedCategoryKey = categoryKey;
    _ensureSelectedPlaceIsVisible();
    notifyListeners();
  }

  void selectPlace(Place place) {
    selectedPlace = place;
    notifyListeners();
  }

  void updateUserPosition(GeoPoint position) {
    userPosition = position;
    notifyListeners();
  }

  /// Fungsi memanggil Gemini AI di Backend berdasarkan ikon yang sedang diklik di peta (selectedPlace)
  Future<void> mintaSaranGeminiAi() async {
    final place = selectedPlace ?? (places.isNotEmpty ? places.first : null);
    final namaTempat = place?.title ?? 'Jembatan dan Kanal Kayutangan';
    final kategori = place?.categoryKey ?? 'Wisata Heritage';
    final jarakMeter = place != null ? calculateDistance(place) : 50;
    final jarakText = '${jarakMeter}m';

    isLoadingAi = true;
    notifyListeners();

    try {
      // Menyesuaikan otomatis apakah ApiConfig.baseUrl sudah ada '/api' atau belum
      final base = ApiConfig.baseUrl.endsWith('/api')
          ? ApiConfig.baseUrl
          : '${ApiConfig.baseUrl}/api';

      final response = await http
          .post(
            Uri.parse('$base/ai/gemini-route'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nama_tempat': namaTempat,
              'kategori': kategori,
              'jarak': jarakText,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['saran_langkah'] != null &&
            data['saran_langkah'].toString().trim().isNotEmpty) {
          saranLangkahAi = data['saran_langkah'].toString().trim();
        }
      } else {
        _setFallbackSaranAi(namaTempat, jarakText);
      }
    } catch (e) {
      debugPrint('Gagal memanggil Gemini AI Backend: $e');
      _setFallbackSaranAi(namaTempat, jarakText);
    } finally {
      isLoadingAi = false;
      notifyListeners();
    }
  }

  void _setFallbackSaranAi(String namaTempat, String jarakText) {
    saranLangkahAi =
        '1. $namaTempat ($jarakText) - Spot kunjungan utama pilihan Anda saat ini.\n'
        '2. Rumah Kolonial 1870 untuk wisata Sejarah di sekitar rute.\n'
        '3. Santap sore di Calathea Garden Kafe atau Kopi Lonceng.';
  }

  /// Dipanggil saat tombol "Pandu Saya ke Rute Ini" di dalam modal Tanya AI ditekan
  void selectSuggestedRoute() {
    selectedPlace ??= places.isEmpty ? null : places.first;
    isRouteGuided = true;
    notifyListeners();
  }

  Future<void> startLocationTracking() async {
    if (_isTracking) return;
    _isTracking = true;
    _simulationStep = 0;
    userPosition = route?.initialUserPosition;
    pesanError = null;
    notifyListeners();

    try {
      final positionStream = await _pantauLokasiPengguna.execute();
      if (!_isTracking) return;
      if (positionStream == null) {
        _startWalkSimulation();
        return;
      }

      _positionStreamSubscription = positionStream.listen(
        updateUserPosition,
        onError: (Object error) {
          pesanError = error.toString();
          _startWalkSimulation();
          notifyListeners();
        },
      );
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
      _startWalkSimulation();
      notifyListeners();
    } on StateError catch (error) {
      pesanError = error.message;
      _startWalkSimulation();
      notifyListeners();
    } on Exception catch (error) {
      pesanError = error.toString();
      _startWalkSimulation();
      notifyListeners();
    }
  }

  void stopLocationTracking() {
    _isTracking = false;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  void advanceSimulation() {
    final path = route?.simulationPath ?? const <GeoPoint>[];
    if (path.isEmpty) return;
    _simulationStep = (_simulationStep + 1) % path.length;
    updateUserPosition(path[_simulationStep]);
  }

  int calculateDistance(Place place) {
    final position = userPosition;
    final latitude = place.latitude;
    final longitude = place.longitude;
    if (position == null || latitude == null || longitude == null) return 0;

    return _hitungJarak.execute(
      from: position,
      to: GeoPoint(latitude: latitude, longitude: longitude),
    );
  }

  void _ensureSelectedPlaceIsVisible() {
    final available = filteredPlaces;
    if (available.isEmpty) {
      selectedPlace = null;
    } else if (selectedPlace == null ||
        !available.any((place) => place.id == selectedPlace!.id)) {
      selectedPlace = available.first;
    }
  }

  void _startWalkSimulation() {
    if (!_isTracking ||
        (_simulationTimer != null && _simulationTimer!.isActive)) {
      return;
    }
    if (route?.simulationPath.isEmpty ?? true) return;

    _simulationTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      advanceSimulation();
    });
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}