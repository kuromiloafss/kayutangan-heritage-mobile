import '../entities/user.dart';

abstract class UserRepository {
  User? findByIdentifier(String identifier);

  bool emailExists(String email);

  void saveUser(User user);
}
