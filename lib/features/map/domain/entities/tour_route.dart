import 'geo_point.dart';

class TourRoute {
  final GeoPoint mapCenter;
  final GeoPoint initialUserPosition;
  final List<GeoPoint> simulationPath;

  const TourRoute({
    required this.mapCenter,
    required this.initialUserPosition,
    required this.simulationPath,
  });
}
