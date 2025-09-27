import 'package:floreria/models/orders/order_item_model.dart';
import 'package:floreria/themes/texts_style.dart';
import 'package:flutter/material.dart';

import '../../utils/strings_utils.dart';
import '../../widgets/custom_card.dart';
import '../order_details/order_details_view.dart';

class OrdersItem extends StatelessWidget {
  const OrdersItem({super.key, required this.item, this.isAdmin = true});

  final OrderItemModel item;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      isShadow: true,
      padding: EdgeInsets.all(10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OrderDetailsView(orderId: item.id);
            },
          ),
        );
      },
      child: Column(
        spacing: 7,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(item.status, style: TextsStyle(context).bodySmall),
          ),

          if (isAdmin)
            Text(
              item.user?.name ?? '',
              style: TextsStyle(context).titleMedium.copyWith(fontSize: 15),
            ),

          if (isAdmin)
            Text(
              'Correo: ${item.user?.email ?? ''}',
              style: TextsStyle(context).bodyMedium,
            ),

          Text(
            'Fecha: ${StringsUtils.formatToDayMonth(item.createdAt)}',
            style: TextsStyle(context).bodyMedium,
          ),

          Text(
            'Hora: ${StringsUtils.formatToHour(item.createdAt)}',
            style: TextsStyle(context).bodyMedium,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              StringsUtils.moneyFormat(item.totalAmount),
              style: TextsStyle(context).bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
