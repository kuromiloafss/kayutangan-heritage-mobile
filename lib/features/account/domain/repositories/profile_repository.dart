import '../entities/profile.dart';

abstract class ProfileRepository {
  Profile getProfile();

  void saveProfile(Profile profile);
}
