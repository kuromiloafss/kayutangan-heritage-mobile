import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class AmbilProfil {
  final ProfileRepository repository;

  const AmbilProfil({required this.repository});

  Profile execute() {
    return repository.getProfile();
  }
}
