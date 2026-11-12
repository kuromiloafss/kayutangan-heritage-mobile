import 'dart:math' as math;

import '../entities/geo_point.dart';

class HitungJarak {
  const HitungJarak();

  int execute({required GeoPoint from, required GeoPoint to}) {
    const earthRadiusMeters = 6371000.0;
    final latitudeDifference = _toRadians(to.latitude - from.latitude);
    final longitudeDifference = _toRadians(to.longitude - from.longitude);
    final fromLatitude = _toRadians(from.latitude);
    final toLatitude = _toRadians(to.latitude);

    final haversine =
        math.pow(math.sin(latitudeDifference / 2), 2) +
        math.cos(fromLatitude) *
            math.cos(toLatitude) *
            math.pow(math.sin(longitudeDifference / 2), 2);
    final centralAngle =
        2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));
    return (earthRadiusMeters * centralAngle).round();
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;
}
