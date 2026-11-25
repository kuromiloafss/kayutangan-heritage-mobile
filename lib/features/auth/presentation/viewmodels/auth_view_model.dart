import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;

  User? user;
  String? pesanError;

  bool isLoading = false;

  AuthViewModel({
    required LoginUser loginUser,
    required RegisterUser registerUser,
  })  : _loginUser = loginUser,
        _registerUser = registerUser;

  // ======================================
  // LOGIN
  // ======================================

  Future<bool> login({
    required String identifier,
    required String password,
    required String languageCode,
  }) async {
    if (isLoading) return false;

    isLoading = true;
    pesanError = null;
    notifyListeners();

    try {
      user = await _loginUser.execute(
        identifier: identifier,
        password: password,
        languageCode: languageCode,
      );

      return true;
    } catch (error) {
      pesanError = _cleanError(error);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ======================================
  // REGISTER
  // ======================================

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String languageCode,
  }) async {
    if (isLoading) return false;

    isLoading = true;
    pesanError = null;
    notifyListeners();

    try {
      user = await _registerUser.execute(
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        languageCode: languageCode,
      );

      return true;
    } catch (error) {
      pesanError = _cleanError(error);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('Invalid argument(s): ', '');
  }
}