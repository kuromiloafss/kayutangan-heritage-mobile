import 'review.dart';

class ReviewSummary {
  final List<Review> reviews;
  final double averageRating;

  const ReviewSummary({required this.reviews, required this.averageRating});
}
