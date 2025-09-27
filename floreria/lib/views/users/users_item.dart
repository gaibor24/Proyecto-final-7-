import 'package:floreria/models/user/user_model.dart';
import 'package:floreria/themes/texts_style.dart';
import 'package:floreria/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class UsersItem extends StatelessWidget {
  const UsersItem({super.key, required this.item});

  final UserModel item;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      isShadow: true,
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre: ${item.name}', style: TextsStyle(context).bodyMedium),
          Text('Correo: ${item.email}', style: TextsStyle(context).bodyMedium),
        ],
      ),
    );
  }
}
