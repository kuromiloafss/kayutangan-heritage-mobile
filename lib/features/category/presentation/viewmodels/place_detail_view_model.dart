import 'package:flutter/foundation.dart';

import '../../domain/entities/place.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/ambil_detail_place.dart';
import '../../domain/usecases/ambil_ulasan.dart';
import '../../domain/usecases/tambah_ulasan.dart';

class PlaceDetailViewModel extends ChangeNotifier {
  final AmbilDetailPlace _ambilDetailPlace;
  final AmbilUlasan _ambilUlasan;
  final TambahUlasan _tambahUlasan;

  Place? place;
  String? categoryOverride;
  List<Review> reviews = const [];
  double averageRating = 0;
  String? pesanError;

  PlaceDetailViewModel({
    required AmbilDetailPlace ambilDetailPlace,
    required AmbilUlasan ambilUlasan,
    required TambahUlasan tambahUlasan,
  }) : _ambilDetailPlace = ambilDetailPlace,
       _ambilUlasan = ambilUlasan,
       _tambahUlasan = tambahUlasan;

  void ambilDetail(String placeId, {String? categoryTitle}) {
    pesanError = null;
    try {
      place = _ambilDetailPlace.execute(placeId: placeId);
      categoryOverride = categoryTitle;
      final summary = _ambilUlasan.execute(
        placeId: placeId,
        initialRating: place!.initialRating,
      );
      reviews = summary.reviews;
      averageRating = summary.averageRating;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      place = null;
      pesanError = error.message;
    }
    notifyListeners();
  }

  bool tambahUlasan({
    required String userName,
    required double rating,
    required String comment,
  }) {
    final currentPlace = place;
    if (currentPlace == null) {
      pesanError = 'Tempat tidak ditemukan';
      notifyListeners();
      return false;
    }

    pesanError = null;
    try {
      _tambahUlasan.execute(
        placeId: currentPlace.id,
        userName: userName,
        rating: rating,
        comment: comment,
      );
      final summary = _ambilUlasan.execute(
        placeId: currentPlace.id,
        initialRating: currentPlace.initialRating,
      );
      reviews = summary.reviews;
      averageRating = summary.averageRating;
      notifyListeners();
      return true;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return false;
  }
}
