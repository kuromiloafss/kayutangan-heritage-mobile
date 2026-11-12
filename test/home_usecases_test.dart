import 'package:flutter_test/flutter_test.dart';
import 'package:kayutangan_heritage/features/category/data/repositories/category_repository_memory.dart';
import 'package:kayutangan_heritage/features/home/data/repositories/home_repository_memory.dart';
import 'package:kayutangan_heritage/features/home/domain/usecases/ambil_kategori_beranda.dart';

void main() {
  test('home categories reuse the shared category repository data', () {
    final categoryRepository = CategoryRepositoryMemory();
    final homeRepository = HomeRepositoryMemory(
      categoryRepository: categoryRepository,
    );

    final categories = AmbilKategoriBeranda(repository: homeRepository)
        .execute();

    expect(categories, hasLength(8));
    expect(categories.map((category) => category.id), [
      'photo_spot',
      'culinary',
      'cafe',
      'souvenir',
      'history',
      'toilet',
      'mosque',
      'lodging',
    ]);
  });
}
