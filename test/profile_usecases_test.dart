import 'package:flutter_test/flutter_test.dart';
import 'package:kayutangan_heritage/features/account/data/repositories/profile_repository_memory.dart';
import 'package:kayutangan_heritage/features/account/domain/entities/profile.dart';
import 'package:kayutangan_heritage/features/account/domain/usecases/ambil_profil.dart';
import 'package:kayutangan_heritage/features/account/domain/usecases/ubah_profil.dart';

void main() {
  test('profile updates are returned by subsequent reads', () {
    final repository = ProfileRepositoryMemory();
    const updatedProfile = Profile(
      name: 'Siti',
      email: 'siti@example.com',
      phone: '+62 812 1234 5678',
      birthDate: '1 Januari 2001',
      domicile: 'Surabaya',
      nameFallback: 'Budi',
    );

    UbahProfil(repository: repository).execute(profile: updatedProfile);

    expect(AmbilProfil(repository: repository).execute(), updatedProfile);
  });
}
