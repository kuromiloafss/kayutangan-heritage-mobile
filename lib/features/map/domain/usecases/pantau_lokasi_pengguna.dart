import '../entities/geo_point.dart';
import '../repositories/user_location_repository.dart';

class PantauLokasiPengguna {
  final UserLocationRepository repository;

  const PantauLokasiPengguna({required this.repository});

  Future<Stream<GeoPoint>?> execute() => repository.watchPosition();
}
