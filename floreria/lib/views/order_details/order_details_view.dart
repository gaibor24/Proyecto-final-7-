import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_details_controller.dart';
import 'order_details_content.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => OrderDetailsController(),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AppBar(title: Text('Detalles del pedido')),
              Expanded(child: OrderDetailsContent(orderId: orderId)),
            ],
          ),
        ),
      ),
    );
  }
}
