import 'package:flutter_test/flutter_test.dart';
import 'package:kayutangan_heritage/features/category/data/repositories/category_repository_memory.dart';
import 'package:kayutangan_heritage/features/map/data/repositories/tour_repository_memory.dart';
import 'package:kayutangan_heritage/features/map/domain/entities/geo_point.dart';
import 'package:kayutangan_heritage/features/map/domain/repositories/user_location_repository.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/ambil_rute_tour.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/ambil_titik_tour.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/hitung_jarak.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/pantau_lokasi_pengguna.dart';
import 'package:kayutangan_heritage/features/map/presentation/viewmodels/map_view_model.dart';

void main() {
  test('tour points reuse category places and provide a simulation route', () {
    final categoryRepository = CategoryRepositoryMemory();
    final repository = TourRepositoryMemory(
      categoryRepository: categoryRepository,
    );

    final places = AmbilTitikTour(repository: repository).execute();
    final route = AmbilRuteTour(repository: repository).execute();

    expect(places, hasLength(11));
    expect(places.first.id, '1');
    expect(route.simulationPath, hasLength(6));
    expect(route.initialUserPosition.latitude, -7.9788);
    expect(route.mapCenter.longitude, 112.6305);
  });

  test('distance calculation returns rounded meters', () {
    const calculateDistance = HitungJarak();

    expect(
      calculateDistance.execute(
        from: const GeoPoint(latitude: -7.9788, longitude: 112.6310),
        to: const GeoPoint(latitude: -7.9792, longitude: 112.6312),
      ),
      inInclusiveRange(49, 51),
    );
  });

  test('map view model filters shared places and advances its route', () {
    final tourRepository = TourRepositoryMemory(
      categoryRepository: CategoryRepositoryMemory(),
    );
    final viewModel = MapViewModel(
      ambilTitikTour: AmbilTitikTour(repository: tourRepository),
      ambilRuteTour: AmbilRuteTour(repository: tourRepository),
      hitungJarak: const HitungJarak(),
      pantauLokasiPengguna: PantauLokasiPengguna(
        repository: _NoLocationRepository(),
      ),
    );
    addTearDown(viewModel.dispose);

    viewModel.selectCategory('cafe');
    viewModel.setSearchQuery('Kopi');
    expect(viewModel.filteredPlaces.map((place) => place.id), ['5']);

    viewModel.advanceSimulation();
    expect(viewModel.userPosition?.latitude, -7.9790);
    expect(viewModel.userPosition?.longitude, 112.6312);
  });
}

class _NoLocationRepository implements UserLocationRepository {
  @override
  Future<Stream<GeoPoint>?> watchPosition() async => null;
}
