import '../entities/tour_route.dart';
import '../repositories/tour_repository.dart';

class AmbilRuteTour {
  final TourRepository repository;

  const AmbilRuteTour({required this.repository});

  TourRoute execute() => repository.getTourRoute();
}
