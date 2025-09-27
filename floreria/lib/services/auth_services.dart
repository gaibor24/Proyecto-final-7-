import 'package:floreria/models/api_model.dart';
import 'package:floreria/models/auth/login_model.dart';

import 'api_services.dart';

class AuthenticationServices {
  Future<ApiModel<bool>> register({
    required String email,
    required String password,
    required String username,
    required bool isAdmin,
  }) async {
    final response = await ApiServices.request(
      endpoint: 'auth/register/',
      method: HttpMethod.post,
      body: {
        'email': email,
        'name': username,
        'password': password,
        'is_admin': isAdmin,
      },
      fromJson: (data) {
        return true;
      },
    );

    return response;
  }

  Future<ApiModel<LoginModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiServices.request(
      endpoint: 'auth/login/',
      method: HttpMethod.post,
      body: {'email': email, 'password': password},
      fromJson: (data) {
        return LoginModel.fromMap(data);
      },
    );

    return response;
  }
}
