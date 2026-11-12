import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  const LoginUser({required this.repository});

  User execute({
    required String identifier,
    required String password,
    String languageCode = 'id',
  }) {
    final normalizedIdentifier = identifier.trim();
    if (normalizedIdentifier.isEmpty) {
      throw ArgumentError(
        languageCode == 'id'
            ? 'Email atau nomor telepon wajib diisi'
            : 'Email or phone number is required',
      );
    }
    if (password.isEmpty) {
      throw ArgumentError(
        languageCode == 'id'
            ? 'Kata sandi wajib diisi'
            : 'Password is required',
      );
    }
    if (normalizedIdentifier.contains('@') &&
        !_isValidEmail(normalizedIdentifier)) {
      throw ArgumentError(
        languageCode == 'id'
            ? 'Format email tidak valid'
            : 'Invalid email format',
      );
    }

    final user = repository.findByIdentifier(normalizedIdentifier);
    if (user == null) {
      throw StateError(
        languageCode == 'id' ? 'Akun tidak ditemukan' : 'Account not found',
      );
    }
    if (user.password != password) {
      throw StateError(
        languageCode == 'id' ? 'Kata sandi salah' : 'Incorrect password',
      );
    }
    return user;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
