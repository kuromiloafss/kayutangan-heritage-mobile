import '../entities/geo_point.dart';

abstract class UserLocationRepository {
  Future<Stream<GeoPoint>?> watchPosition();
}
