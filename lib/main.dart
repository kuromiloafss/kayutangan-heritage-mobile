import 'package:flutter/material.dart';

import 'core/localization/app_language.dart';
import 'features/account/data/repositories/profile_repository_memory.dart';
import 'features/account/domain/usecases/ambil_profil.dart';
import 'features/account/domain/usecases/ubah_profil.dart';
import 'features/account/presentation/viewmodels/profile_view_model.dart';
import 'features/auth/data/repositories/user_repository_memory.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/auth/presentation/views/login_page.dart';
import 'features/auth/presentation/views/welcome_page.dart';
import 'features/category/data/repositories/category_repository_memory.dart';
import 'features/category/domain/usecases/ambil_detail_place.dart';
import 'features/category/domain/usecases/ambil_kategori.dart';
import 'features/category/domain/usecases/ambil_place_by_kategori.dart';
import 'features/category/domain/usecases/ambil_ulasan.dart';
import 'features/category/domain/usecases/tambah_ulasan.dart';
import 'features/category/presentation/viewmodels/category_view_model.dart';
import 'features/category/presentation/viewmodels/place_detail_view_model.dart';
import 'features/home/data/repositories/home_repository_memory.dart';
import 'features/home/domain/usecases/ambil_kategori_beranda.dart';
import 'features/home/presentation/views/home_page.dart';
import 'features/home/presentation/viewmodels/home_view_model.dart';
import 'features/map/data/repositories/tour_repository_memory.dart';
import 'features/map/data/repositories/user_location_repository_device.dart';
import 'features/map/domain/usecases/ambil_rute_tour.dart';
import 'features/map/domain/usecases/ambil_titik_tour.dart';
import 'features/map/domain/usecases/hitung_jarak.dart';
import 'features/map/domain/usecases/pantau_lokasi_pengguna.dart';
import 'features/map/presentation/viewmodels/map_view_model.dart';
import 'features/ticket/data/repositories/ticket_repository_memory.dart';
import 'features/ticket/domain/usecases/ambil_default_pesanan.dart';
import 'features/ticket/domain/usecases/ambil_tiket.dart';
import 'features/ticket/domain/usecases/ambil_tiket_saya.dart';
import 'features/ticket/domain/usecases/buat_pesanan.dart';
import 'features/ticket/domain/usecases/hitung_total.dart';
import 'features/ticket/domain/usecases/proses_pembayaran.dart';
import 'features/ticket/domain/usecases/tandai_tiket_digunakan.dart';
import 'features/ticket/presentation/viewmodels/ticket_view_model.dart';

void main() {
  final userRepository = UserRepositoryMemory();
  final profileRepository = ProfileRepositoryMemory();
  final categoryRepository = CategoryRepositoryMemory();
  final homeRepository = HomeRepositoryMemory(
    categoryRepository: categoryRepository,
  );
  final tourRepository = TourRepositoryMemory(
    categoryRepository: categoryRepository,
  );
  final userLocationRepository = UserLocationRepositoryDevice();
  final ticketRepository = TicketRepositoryMemory();
  final authViewModel = AuthViewModel(
    loginUser: LoginUser(repository: userRepository),
    registerUser: RegisterUser(repository: userRepository),
  );
  final profileViewModel = ProfileViewModel(
    ambilProfil: AmbilProfil(repository: profileRepository),
    ubahProfil: UbahProfil(repository: profileRepository),
  );
  final categoryViewModel = CategoryViewModel(
    ambilKategori: AmbilKategori(repository: categoryRepository),
    ambilPlaceByKategori: AmbilPlaceByKategori(repository: categoryRepository),
  );
  final homeViewModel = HomeViewModel(
    ambilKategoriBeranda: AmbilKategoriBeranda(repository: homeRepository),
  );
  final placeDetailViewModel = PlaceDetailViewModel(
    ambilDetailPlace: AmbilDetailPlace(repository: categoryRepository),
    ambilUlasan: AmbilUlasan(repository: categoryRepository),
    tambahUlasan: TambahUlasan(repository: categoryRepository),
  );
  final mapViewModel = MapViewModel(
    ambilTitikTour: AmbilTitikTour(repository: tourRepository),
    ambilRuteTour: AmbilRuteTour(repository: tourRepository),
    hitungJarak: const HitungJarak(),
    pantauLokasiPengguna: PantauLokasiPengguna(
      repository: userLocationRepository,
    ),
  );
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
  runApp(
    MyApp(
      authViewModel: authViewModel,
      profileViewModel: profileViewModel,
      categoryViewModel: categoryViewModel,
      placeDetailViewModel: placeDetailViewModel,
      mapViewModel: mapViewModel,
      ticketViewModel: ticketViewModel,
      homeViewModel: homeViewModel,
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthViewModel authViewModel;
  final ProfileViewModel profileViewModel;
  final CategoryViewModel categoryViewModel;
  final PlaceDetailViewModel placeDetailViewModel;
  final MapViewModel mapViewModel;
  final TicketViewModel ticketViewModel;
  final HomeViewModel homeViewModel;

  const MyApp({
    super.key,
    required this.authViewModel,
    required this.profileViewModel,
    required this.categoryViewModel,
    required this.placeDetailViewModel,
    required this.mapViewModel,
    required this.ticketViewModel,
    required this.homeViewModel,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.authViewModel.dispose();
    widget.profileViewModel.dispose();
    widget.categoryViewModel.dispose();
    widget.placeDetailViewModel.dispose();
    widget.mapViewModel.dispose();
    widget.ticketViewModel.dispose();
    widget.homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Saat bahasa berubah, seluruh widget di dalam aplikasi otomatis ter-rebuild dengan bahasa baru
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kayutangan Heritage',
          theme: ThemeData(
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF334227),
            ),
            useMaterial3: true,
          ),
          home: WelcomePage(
            vm: widget.authViewModel,
            profileViewModel: widget.profileViewModel,
            categoryViewModel: widget.categoryViewModel,
            placeDetailViewModel: widget.placeDetailViewModel,
            mapViewModel: widget.mapViewModel,
            ticketViewModel: widget.ticketViewModel,
            homeViewModel: widget.homeViewModel,
          ),
          onGenerateRoute: (settings) {
            if (settings.name == '/login') {
              return MaterialPageRoute<void>(
                builder: (context) => LoginPage(
                  vm: widget.authViewModel,
                  profileViewModel: widget.profileViewModel,
                  categoryViewModel: widget.categoryViewModel,
                  placeDetailViewModel: widget.placeDetailViewModel,
                  mapViewModel: widget.mapViewModel,
                  ticketViewModel: widget.ticketViewModel,
                  homeViewModel: widget.homeViewModel,
                ),
              );
            }
            if (settings.name == '/home') {
              return MaterialPageRoute<void>(
                builder: (context) => HomePage(
                  profileViewModel: widget.profileViewModel,
                  categoryViewModel: widget.categoryViewModel,
                  placeDetailViewModel: widget.placeDetailViewModel,
                  mapViewModel: widget.mapViewModel,
                  ticketViewModel: widget.ticketViewModel,
                  homeViewModel: widget.homeViewModel,
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
