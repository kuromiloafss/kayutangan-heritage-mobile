import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;

  User? user;
  String? pesanError;

  AuthViewModel({
    required LoginUser loginUser,
    required RegisterUser registerUser,
  }) : _loginUser = loginUser,
       _registerUser = registerUser;

  bool login({
    required String identifier,
    required String password,
    required String languageCode,
  }) {
    pesanError = null;
    try {
      user = _loginUser.execute(
        identifier: identifier,
        password: password,
        languageCode: languageCode,
      );
      notifyListeners();
      return true;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return false;
  }

  bool register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String languageCode,
  }) {
    pesanError = null;
    try {
      user = _registerUser.execute(
        name: name,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        languageCode: languageCode,
      );
      notifyListeners();
      return true;
    } on ArgumentError catch (error) {
      pesanError = error.message.toString();
    } on StateError catch (error) {
      pesanError = error.message;
    }
    notifyListeners();
    return false;
  }
}
