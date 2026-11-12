import '../entities/review_summary.dart';
import '../repositories/category_repository.dart';

class AmbilUlasan {
  final CategoryRepository repository;

  const AmbilUlasan({required this.repository});

  ReviewSummary execute({
    required String placeId,
    required double initialRating,
  }) {
    final reviews = repository.getReviews(placeId);
    if (reviews.isEmpty) {
      return ReviewSummary(reviews: reviews, averageRating: initialRating);
    }

    final total = reviews.fold<double>(0, (sum, review) => sum + review.rating);
    final averageRating = double.parse(
      (total / reviews.length).toStringAsFixed(1),
    );
    return ReviewSummary(reviews: reviews, averageRating: averageRating);
  }
}
