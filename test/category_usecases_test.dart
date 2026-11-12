import 'package:flutter_test/flutter_test.dart';
import 'package:kayutangan_heritage/features/category/data/repositories/category_repository_memory.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_kategori.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_place_by_kategori.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_ulasan.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/tambah_ulasan.dart';

void main() {
  test('category queries distinguish home categories from all categories', () {
    final repository = CategoryRepositoryMemory();
    final useCase = AmbilKategori(repository: repository);

    expect(useCase.execute(homeOnly: true), hasLength(8));
    expect(useCase.execute(), hasLength(9));
    expect(
      useCase.execute().map((category) => category.title),
      contains('Ulasan'),
    );
  });

  test('place reviews update their summary and reject empty submissions', () {
    final repository = CategoryRepositoryMemory();
    final places = AmbilPlaceByKategori(repository: repository)
        .execute(categoryTitle: 'Spot Foto');
    final place = places.first;
    final getReviews = AmbilUlasan(repository: repository);
    final addReview = TambahUlasan(repository: repository);

    expect(
      () => addReview.execute(
        placeId: place.id,
        userName: ' ',
        rating: 5,
        comment: 'Bagus',
      ),
      throwsArgumentError,
    );
    addReview.execute(
      placeId: place.id,
      userName: 'Budi',
      rating: 3,
      comment: 'Cukup nyaman',
    );

    final summary = getReviews.execute(
      placeId: place.id,
      initialRating: place.initialRating,
    );
    expect(summary.reviews, hasLength(3));
    expect(summary.reviews.first.userName, 'Budi');
    expect(summary.averageRating, 4.2);
  });
}
