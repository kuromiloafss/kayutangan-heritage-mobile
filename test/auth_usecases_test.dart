import 'package:flutter_test/flutter_test.dart';
import 'package:kayutangan_heritage/features/auth/data/repositories/user_repository_memory.dart';
import 'package:kayutangan_heritage/features/auth/domain/usecases/login_user.dart';
import 'package:kayutangan_heritage/features/auth/domain/usecases/register_user.dart';

void main() {
  test('registration validates email and rejects duplicate accounts', () {
    final repository = UserRepositoryMemory();
    final registerUser = RegisterUser(repository: repository);

    expect(
      () => registerUser.execute(
        name: 'Budi',
        email: 'not-an-email',
        phone: '',
        password: 'secret',
        confirmPassword: 'secret',
      ),
      throwsArgumentError,
    );

    registerUser.execute(
      name: 'Budi',
      email: 'budi@example.com',
      phone: '',
      password: 'secret',
      confirmPassword: 'secret',
    );
    expect(
      () => registerUser.execute(
        name: 'Budi Lain',
        email: 'BUDI@example.com',
        phone: '',
        password: 'secret',
        confirmPassword: 'secret',
      ),
      throwsStateError,
    );
  });

  test('login requires a registered user and matching password', () {
    final repository = UserRepositoryMemory();
    RegisterUser(repository: repository).execute(
      name: 'Budi',
      email: 'budi@example.com',
      phone: '',
      password: 'secret',
      confirmPassword: 'secret',
    );
    final loginUser = LoginUser(repository: repository);

    expect(
      () => loginUser.execute(identifier: '', password: 'secret'),
      throwsArgumentError,
    );
    expect(
      () =>
          loginUser.execute(identifier: 'budi@example.com', password: 'wrong'),
      throwsStateError,
    );
    expect(
      loginUser
          .execute(identifier: 'budi@example.com', password: 'secret')
          .name,
      'Budi',
    );
  });
}
