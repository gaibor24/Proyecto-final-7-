import 'package:flutter/material.dart';

import '../models/user/user_model.dart';
import '../services/user_services.dart';
import '../status/status_page_value.dart';

class UsersController with ChangeNotifier {
  final _service = UserServices();

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  StatusPage _status = StatusPage.initial;
  StatusPage get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getUsers() async {
    _status = StatusPage.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getUsers();

    if (response.success) {
      final data = response.data;

      _users = data ?? [];

      _status = _users.isEmpty ? StatusPage.empty : StatusPage.success;
    } else {
      _status = StatusPage.errorApp;
      _errorMessage = response.message;
    }

    notifyListeners();
  }
}
