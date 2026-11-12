import '../entities/review.dart';
import '../repositories/category_repository.dart';

class TambahUlasan {
  final CategoryRepository repository;

  const TambahUlasan({required this.repository});

  Review execute({
    required String placeId,
    required String userName,
    required double rating,
    required String comment,
  }) {
    if (userName.trim().isEmpty || comment.trim().isEmpty) {
      throw ArgumentError('Nama dan ulasan wajib diisi');
    }
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating harus antara 1 sampai 5');
    }
    if (repository.getPlaceById(placeId) == null) {
      throw StateError('Tempat tidak ditemukan');
    }

    final review = Review(
      userName: userName.trim(),
      rating: rating,
      date: 'Baru saja',
      comment: comment.trim(),
    );
    repository.addReview(placeId, review);
    return review;
  }
}
