import 'package:flutter/foundation.dart';

import '../../../category/domain/entities/kategori.dart';
import '../../domain/usecases/ambil_kategori_beranda.dart';

class HomeViewModel extends ChangeNotifier {
  final AmbilKategoriBeranda _ambilKategoriBeranda;

  List<Kategori> kategori = const [];
  String? pesanError;

  HomeViewModel({required AmbilKategoriBeranda ambilKategoriBeranda})
    : _ambilKategoriBeranda = ambilKategoriBeranda {
    ambilDataKategori();
  }

  void ambilDataKategori() {
    pesanError = null;
    try {
      kategori = _ambilKategoriBeranda.execute();
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
  }
}
