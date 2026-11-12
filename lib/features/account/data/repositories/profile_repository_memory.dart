import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryMemory implements ProfileRepository {
  Profile _data = const Profile(
    name: 'Budi',
    email: 'BudiKeren@gmail.com',
    phone: '+62 812 0000 0000',
    birthDate: '12 Juli 2000',
    domicile: 'Malang',
    nameFallback: 'Budi',
  );

  @override
  Profile getProfile() => _data;

  @override
  void saveProfile(Profile profile) {
    _data = profile;
  }
}
