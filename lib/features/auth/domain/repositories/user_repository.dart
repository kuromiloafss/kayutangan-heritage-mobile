import '../entities/user.dart';

abstract class UserRepository {
  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<User> login({
    required String identifier,
    required String password,
  });
}