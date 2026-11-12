import 'package:flutter/foundation.dart';

import '../../domain/entities/profile.dart';
import '../../domain/usecases/ambil_profil.dart';
import '../../domain/usecases/ubah_profil.dart';

class ProfileViewModel extends ChangeNotifier {
  final AmbilProfil _ambilProfil;
  final UbahProfil _ubahProfil;

  Profile? profil;
  String? pesanError;

  ProfileViewModel({
    required AmbilProfil ambilProfil,
    required UbahProfil ubahProfil,
  }) : _ambilProfil = ambilProfil,
       _ubahProfil = ubahProfil {
    ambilDataProfil();
  }

  void ambilDataProfil() {
    pesanError = null;
    try {
      profil = _ambilProfil.execute();
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
  }

  bool ubahDataProfil({
    required String name,
    required String email,
    required String phone,
    required String birthDate,
    required String domicile,
  }) {
    pesanError = null;
    final currentProfile = profil;
    if (currentProfile == null) {
      pesanError = 'Profil tidak tersedia';
      notifyListeners();
      return false;
    }
    try {
      profil = _ubahProfil.execute(
        profile: Profile(
          name: name,
          email: email,
          phone: phone,
          birthDate: birthDate,
          domicile: domicile,
          nameFallback: currentProfile.nameFallback,
        ),
      );
      notifyListeners();
      return true;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return false;
  }
}
