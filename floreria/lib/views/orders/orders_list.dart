import 'package:floreria/models/orders/order_item_model.dart';
import 'package:flutter/material.dart';

import 'orders_item.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key, required this.orders});

  final List<OrderItemModel> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: orders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, i) => SizedBox(height: 15),
      itemBuilder: (_, i) {
        return OrdersItem(item: orders[i]);
      },
    );
  }
}
