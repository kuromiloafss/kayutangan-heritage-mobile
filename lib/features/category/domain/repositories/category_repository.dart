import '../entities/kategori.dart';
import '../entities/place.dart';
import '../entities/review.dart';

abstract class CategoryRepository {
  List<Kategori> getCategories({bool homeOnly = false});

  List<Place> getPlacesByCategory(String categoryTitle);

  List<Place> getTourPlaces();

  Place? getPlaceById(String placeId);

  List<Review> getReviews(String placeId);

  void addReview(String placeId, Review review);
}
