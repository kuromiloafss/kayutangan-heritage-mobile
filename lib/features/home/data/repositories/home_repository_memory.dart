import '../../../category/domain/entities/kategori.dart';
import '../../../category/domain/repositories/category_repository.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryMemory implements HomeRepository {
  final CategoryRepository _categoryRepository;

  const HomeRepositoryMemory({required CategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  List<Kategori> getHomeCategories() =>
      _categoryRepository.getCategories(homeOnly: true);
}
