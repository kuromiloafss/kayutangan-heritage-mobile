import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryMemory implements UserRepository {
  final List<User> _data = [];

  @override
  User? findByIdentifier(String identifier) {
    final normalizedIdentifier = identifier.toLowerCase();
    for (final user in _data) {
      if (user.email.toLowerCase() == normalizedIdentifier ||
          user.phone.toLowerCase() == normalizedIdentifier) {
        return user;
      }
    }
    return null;
  }

  @override
  bool emailExists(String email) {
    final normalizedEmail = email.toLowerCase();
    return _data.any((user) => user.email.toLowerCase() == normalizedEmail);
  }

  @override
  void saveUser(User user) {
    _data.add(user);
  }
}
