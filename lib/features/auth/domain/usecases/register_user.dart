import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  const RegisterUser({required this.repository});

  User execute({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    String languageCode = 'id',
  }) {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim();

    if (normalizedName.isEmpty || normalizedEmail.isEmpty || password.isEmpty) {
      throw ArgumentError(
        languageCode == 'id'
            ? 'Mohon lengkapi formulir pendaftaran!'
            : 'Please complete the registration form!',
      );
    }
    if (!_isValidEmail(normalizedEmail)) {
      throw ArgumentError(
        languageCode == 'id'
            ? 'Format email tidak valid'
            : 'Invalid email format',
      );
    }
    if (password != confirmPassword) {
      throw ArgumentError(
        languageCode == 'id'
            ? 'Konfirmasi kata sandi tidak cocok!'
            : 'Passwords do not match!',
      );
    }
    if (repository.emailExists(normalizedEmail)) {
      throw StateError(
        languageCode == 'id'
            ? 'Email sudah terdaftar'
            : 'Email is already registered',
      );
    }

    final user = User(
      name: normalizedName,
      email: normalizedEmail,
      phone: phone.trim(),
      password: password,
    );
    repository.saveUser(user);
    return user;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
}
