import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  const LoginUser({
    required this.repository,
  });

  Future<User> execute({
    required String identifier,
    required String password,
    String languageCode = 'id',
  }) async {
    final normalizedIdentifier = identifier.trim();

    if (normalizedIdentifier.isEmpty) {
      throw ArgumentError(
        'Email atau nomor telepon wajib diisi.',
      );
    }

    if (password.isEmpty) {
      throw ArgumentError(
        'Kata sandi wajib diisi.',
      );
    }

    if (normalizedIdentifier.contains('@') &&
        !_isValidEmail(normalizedIdentifier)) {
      throw ArgumentError(
        'Format email tidak valid.',
      );
    }

    return await repository.login(
      identifier: normalizedIdentifier,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }
}