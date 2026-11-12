import '../../../category/domain/entities/place.dart';
import '../repositories/tour_repository.dart';

class AmbilTitikTour {
  final TourRepository repository;

  const AmbilTitikTour({required this.repository});

  List<Place> execute() => repository.getTourPlaces();
}
