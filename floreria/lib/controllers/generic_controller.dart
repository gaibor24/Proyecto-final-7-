import 'package:floreria/services/token_services.dart';
import 'package:flutter/material.dart';

import '../models/user/user_model.dart';
import '../services/user_services.dart';

enum TokenStatus { initial, noTokenExists, tokenExists }

class GenericController with ChangeNotifier {
  final _service = TokenServices();
  final _userService = UserServices();

  UserModel? _user;
  UserModel? get user => _user;

  Future<TokenStatus> getToken() async {
    final userToken = await _service.getToken() ?? '';

    if (userToken.isNotEmpty) {
      return TokenStatus.tokenExists;
    } else {
      await Future.delayed(const Duration(seconds: 2));
      return TokenStatus.noTokenExists;
    }
  }

  Future<UserModel?> getUser() async {
    final response = await _userService.getUser();

    if (response.success && response.data != null) {
      return response.data;
    } else {
      return null;
    }
  }

  void setUser(UserModel data) async {
    _user = data;
    notifyListeners();
  }

  Future<bool> logout() async {
    _user = null;
    await TokenServices().clearToken();
    return true;
  }
}
