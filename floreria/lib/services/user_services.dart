import '../models/api_model.dart';
import '../models/user/user_model.dart';
import 'api_services.dart';

class UserServices {
  Future<ApiModel<UserModel>> getUser() async {
    final response = await ApiServices.request(
      endpoint: 'user',
      method: HttpMethod.get,
      fromJson: (data) {
        return UserModel.fromMap(data['user']);
      },
    );

    return response;
  }

  Future<ApiModel<List<UserModel>>> getUsers() async {
    final response = await ApiServices.request(
      endpoint: 'users',
      method: HttpMethod.get,
      fromJson: (data) {
        final list =
            ((data['users'] ?? []) as List).map((e) {
              return UserModel.fromMap(e);
            }).toList();

        return list;
      },
    );

    return response;
  }
}
