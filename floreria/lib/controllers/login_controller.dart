import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import '../services/token_services.dart';

class LoginController with ChangeNotifier {
  final _service = AuthenticationServices();

  String _email = '';
  String get email => _email;

  String _password = '';
  String get password => _password;

  void changeEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void changePassword(String value) {
    _password = value;
    notifyListeners();
  }

  /// Login de usuario
  Future<String> loginUser() async {
    final response = await _service.login(email: email, password: password);

    if (response.success) {
      await TokenServices().saveToken(response.data?.accessToken ?? '');
      return '';
    } else {
      return response.message;
    }
  }
}
