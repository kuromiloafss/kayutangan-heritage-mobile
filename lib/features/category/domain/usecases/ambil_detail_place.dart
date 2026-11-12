import '../entities/place.dart';
import '../repositories/category_repository.dart';

class AmbilDetailPlace {
  final CategoryRepository repository;

  const AmbilDetailPlace({required this.repository});

  Place execute({required String placeId}) {
    final place = repository.getPlaceById(placeId);
    if (place == null) {
      throw StateError('Tempat tidak ditemukan');
    }
    return place;
  }
}
