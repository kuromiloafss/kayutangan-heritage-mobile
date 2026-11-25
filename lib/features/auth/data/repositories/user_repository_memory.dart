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
  Future<User> login({
    required String identifier,
    required String password,
  }) async {
    final user = findByIdentifier(identifier);
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }

  @override
  Future<User> register({
    required String email,
    required String name,
    required String password,
    required String phone,
  }) async {
    if (emailExists(email)) {
      throw Exception('Email is already registered');
    }

    final user = User(
      name: name,
      email: email,
      phone: phone,
    );

    saveUser(user);
    return user;
  }

  @override
  void saveUser(User user) {
    _data.add(user);
  }
}