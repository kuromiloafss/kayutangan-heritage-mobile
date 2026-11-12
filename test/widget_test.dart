// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:kayutangan_heritage/main.dart';
import 'package:kayutangan_heritage/features/auth/data/repositories/user_repository_memory.dart';
import 'package:kayutangan_heritage/features/auth/domain/usecases/login_user.dart';
import 'package:kayutangan_heritage/features/auth/domain/usecases/register_user.dart';
import 'package:kayutangan_heritage/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:kayutangan_heritage/features/account/data/repositories/profile_repository_memory.dart';
import 'package:kayutangan_heritage/features/account/domain/usecases/ambil_profil.dart';
import 'package:kayutangan_heritage/features/account/domain/usecases/ubah_profil.dart';
import 'package:kayutangan_heritage/features/account/presentation/viewmodels/profile_view_model.dart';
import 'package:kayutangan_heritage/features/category/data/repositories/category_repository_memory.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_detail_place.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_kategori.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_place_by_kategori.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/ambil_ulasan.dart';
import 'package:kayutangan_heritage/features/category/domain/usecases/tambah_ulasan.dart';
import 'package:kayutangan_heritage/features/category/presentation/viewmodels/category_view_model.dart';
import 'package:kayutangan_heritage/features/category/presentation/viewmodels/place_detail_view_model.dart';
import 'package:kayutangan_heritage/features/map/data/repositories/tour_repository_memory.dart';
import 'package:kayutangan_heritage/features/map/data/repositories/user_location_repository_device.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/ambil_rute_tour.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/ambil_titik_tour.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/hitung_jarak.dart';
import 'package:kayutangan_heritage/features/map/domain/usecases/pantau_lokasi_pengguna.dart';
import 'package:kayutangan_heritage/features/map/presentation/viewmodels/map_view_model.dart';
import 'package:kayutangan_heritage/features/home/data/repositories/home_repository_memory.dart';
import 'package:kayutangan_heritage/features/home/domain/usecases/ambil_kategori_beranda.dart';
import 'package:kayutangan_heritage/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:kayutangan_heritage/features/ticket/data/repositories/ticket_repository_memory.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/ambil_tiket.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/ambil_tiket_saya.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/ambil_default_pesanan.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/buat_pesanan.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/hitung_total.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/proses_pembayaran.dart';
import 'package:kayutangan_heritage/features/ticket/domain/usecases/tandai_tiket_digunakan.dart';
import 'package:kayutangan_heritage/features/ticket/presentation/viewmodels/ticket_view_model.dart';

void main() {
  testWidgets('Welcome screen is displayed', (WidgetTester tester) async {
    final repository = UserRepositoryMemory();
    final viewModel = AuthViewModel(
      loginUser: LoginUser(repository: repository),
      registerUser: RegisterUser(repository: repository),
    );
    final profileRepository = ProfileRepositoryMemory();
    final profileViewModel = ProfileViewModel(
      ambilProfil: AmbilProfil(repository: profileRepository),
      ubahProfil: UbahProfil(repository: profileRepository),
    );
    final categoryRepository = CategoryRepositoryMemory();
    final categoryViewModel = CategoryViewModel(
      ambilKategori: AmbilKategori(repository: categoryRepository),
      ambilPlaceByKategori: AmbilPlaceByKategori(
        repository: categoryRepository,
      ),
    );
    final homeRepository = HomeRepositoryMemory(
      categoryRepository: categoryRepository,
    );
    final homeViewModel = HomeViewModel(
      ambilKategoriBeranda: AmbilKategoriBeranda(repository: homeRepository),
    );
    final placeDetailViewModel = PlaceDetailViewModel(
      ambilDetailPlace: AmbilDetailPlace(repository: categoryRepository),
      ambilUlasan: AmbilUlasan(repository: categoryRepository),
      tambahUlasan: TambahUlasan(repository: categoryRepository),
    );
    final tourRepository = TourRepositoryMemory(
      categoryRepository: categoryRepository,
    );
    final mapViewModel = MapViewModel(
      ambilTitikTour: AmbilTitikTour(repository: tourRepository),
      ambilRuteTour: AmbilRuteTour(repository: tourRepository),
      hitungJarak: const HitungJarak(),
      pantauLokasiPengguna: PantauLokasiPengguna(
        repository: UserLocationRepositoryDevice(),
      ),
    );
    final ticketRepository = TicketRepositoryMemory();
    final hitungTotal = HitungTotal(repository: ticketRepository);
    final ticketViewModel = TicketViewModel(
      ambilTiket: AmbilTiket(repository: ticketRepository),
      ambilTiketSaya: AmbilTiketSaya(repository: ticketRepository),
      ambilDefaultPesanan: AmbilDefaultPesanan(repository: ticketRepository),
      buatPesanan: BuatPesanan(
        repository: ticketRepository,
        hitungTotal: hitungTotal,
      ),
      prosesPembayaran: ProsesPembayaran(
        repository: ticketRepository,
        hitungTotal: hitungTotal,
      ),
      tandaiTiketDigunakan: TandaiTiketDigunakan(repository: ticketRepository),
    );
    await tester.pumpWidget(
      MyApp(
        authViewModel: viewModel,
        profileViewModel: profileViewModel,
        categoryViewModel: categoryViewModel,
        placeDetailViewModel: placeDetailViewModel,
        mapViewModel: mapViewModel,
        ticketViewModel: ticketViewModel,
        homeViewModel: homeViewModel,
      ),
    );

    expect(find.text('Kampoeng Heritage\nKayutangan'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
