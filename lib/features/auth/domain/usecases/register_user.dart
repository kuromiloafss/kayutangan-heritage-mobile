import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  const RegisterUser({
    required this.repository,
  });

  Future<User> execute({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    String languageCode = 'id',
  }) async {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedName.isEmpty ||
        normalizedEmail.isEmpty ||
        phone.trim().isEmpty ||
        password.isEmpty) {
      throw ArgumentError(
        'Mohon lengkapi semua formulir pendaftaran!',
      );
    }

    if (!_isValidEmail(normalizedEmail)) {
      throw ArgumentError(
        'Format email tidak valid.',
      );
    }

    if (password.length < 8) {
      throw ArgumentError(
        'Kata sandi minimal 8 karakter.',
      );
    }

    if (password != confirmPassword) {
      throw ArgumentError(
        'Konfirmasi kata sandi tidak cocok!',
      );
    }

    return await repository.register(
      name: normalizedName,
      email: normalizedEmail,
      phone: phone.trim(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }
}