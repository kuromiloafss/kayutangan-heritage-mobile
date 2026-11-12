import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UbahProfil {
  final ProfileRepository repository;

  const UbahProfil({required this.repository});

  Profile execute({required Profile profile}) {
    repository.saveProfile(profile);
    return profile;
  }
}
