import '../entities/kategori.dart';
import '../repositories/category_repository.dart';

class AmbilKategori {
  final CategoryRepository repository;

  const AmbilKategori({required this.repository});

  List<Kategori> execute({bool homeOnly = false}) {
    return repository.getCategories(homeOnly: homeOnly);
  }
}
