import '../entities/place.dart';
import '../repositories/category_repository.dart';

class AmbilPlaceByKategori {
  final CategoryRepository repository;

  const AmbilPlaceByKategori({required this.repository});

  List<Place> execute({required String categoryTitle}) {
    return repository.getPlacesByCategory(categoryTitle);
  }
}
