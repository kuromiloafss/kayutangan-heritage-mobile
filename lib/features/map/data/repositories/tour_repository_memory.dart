import '../../../category/domain/repositories/category_repository.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/entities/tour_route.dart';
import '../../domain/repositories/tour_repository.dart';
import '../../../category/domain/entities/place.dart';

class TourRepositoryMemory implements TourRepository {
  final CategoryRepository _categoryRepository;

  const TourRepositoryMemory({required CategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  static const _tourRoute = TourRoute(
    mapCenter: GeoPoint(latitude: -7.9785, longitude: 112.6305),
    initialUserPosition: GeoPoint(latitude: -7.9788, longitude: 112.6310),
    simulationPath: [
      GeoPoint(latitude: -7.9788, longitude: 112.6310),
      GeoPoint(latitude: -7.9790, longitude: 112.6312),
      GeoPoint(latitude: -7.9792, longitude: 112.6312),
      GeoPoint(latitude: -7.9784, longitude: 112.6304),
      GeoPoint(latitude: -7.9781, longitude: 112.6301),
      GeoPoint(latitude: -7.9776, longitude: 112.6298),
    ],
  );

  @override
  List<Place> getTourPlaces() => _categoryRepository.getTourPlaces();

  @override
  TourRoute getTourRoute() => _tourRoute;
}
