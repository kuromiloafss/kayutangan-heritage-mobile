import '../../../category/domain/entities/kategori.dart';
import '../repositories/home_repository.dart';

class AmbilKategoriBeranda {
  final HomeRepository repository;

  const AmbilKategoriBeranda({required this.repository});

  List<Kategori> execute() => repository.getHomeCategories();
}
