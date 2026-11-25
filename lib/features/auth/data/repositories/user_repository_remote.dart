import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class UserRepositoryRemote implements UserRepository {
  final AuthRemoteDataSource dataSource;

  UserRepositoryRemote({
    required this.dataSource,
  });

  @override
  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    return dataSource.registerUser(
      nama: name,
      email: email,
      telepon: phone,
      password: password,
    );
  }

  @override
  Future<User> login({
    required String identifier,
    required String password,
  }) {
    return dataSource.loginUser(
      identifier: identifier,
      password: password,
    );
  }
}