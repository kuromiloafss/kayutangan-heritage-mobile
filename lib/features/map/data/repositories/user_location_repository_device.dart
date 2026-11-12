import 'package:geolocator/geolocator.dart';

import '../../domain/entities/geo_point.dart';
import '../../domain/repositories/user_location_repository.dart';

class UserLocationRepositoryDevice implements UserLocationRepository {
  @override
  Future<Stream<GeoPoint>?> watchPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return null;
    }

    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 5,
      ),
    ).map(
      (position) =>
          GeoPoint(latitude: position.latitude, longitude: position.longitude),
    );
  }
}
