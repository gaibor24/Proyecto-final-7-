import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class RegisterController with ChangeNotifier {
  final _service = AuthenticationServices();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _email = '';
  String get email => _email;

  String _password = '';
  String get password => _password;

  String _name = '';
  String get name => _name;

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  void changeEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void changePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void changeName(String value) {
    _name = value;
    notifyListeners();
  }

  void changeIsAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }

  /// Login de usuario
  Future<String> register() async {
    final response = await _service.register(
      email: email,
      password: password,
      username: name,
      isAdmin: isAdmin,
    );

    if (response.success) {
      return '';
    } else {
      return response.message;
    }
  }
}
