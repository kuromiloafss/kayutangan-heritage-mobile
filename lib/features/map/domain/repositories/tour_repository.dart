import '../../../category/domain/entities/place.dart';
import '../entities/tour_route.dart';

abstract class TourRepository {
  List<Place> getTourPlaces();

  TourRoute getTourRoute();
}
