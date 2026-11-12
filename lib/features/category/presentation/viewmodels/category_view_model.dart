import 'package:flutter/foundation.dart';

import '../../domain/entities/kategori.dart';
import '../../domain/entities/place.dart';
import '../../domain/usecases/ambil_kategori.dart';
import '../../domain/usecases/ambil_place_by_kategori.dart';

class CategoryViewModel extends ChangeNotifier {
  final AmbilKategori _ambilKategori;
  final AmbilPlaceByKategori _ambilPlaceByKategori;

  List<Kategori> kategori = const [];
  List<Place> places = const [];
  String? pesanError;

  CategoryViewModel({
    required AmbilKategori ambilKategori,
    required AmbilPlaceByKategori ambilPlaceByKategori,
  }) : _ambilKategori = ambilKategori,
       _ambilPlaceByKategori = ambilPlaceByKategori {
    ambilDataKategori();
  }

  void ambilDataKategori() {
    pesanError = null;
    try {
      kategori = _ambilKategori.execute();
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
  }

  void ambilPlaceByKategoriData(String categoryTitle) {
    pesanError = null;
    try {
      places = _ambilPlaceByKategori.execute(categoryTitle: categoryTitle);
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
  }
}
