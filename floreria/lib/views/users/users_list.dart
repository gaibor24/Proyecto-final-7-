import 'package:floreria/models/user/user_model.dart';
import 'package:flutter/material.dart';

import 'users_item.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, i) => SizedBox(height: 15),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        return UsersItem(item: users[i]);
      },
    );
  }
}
