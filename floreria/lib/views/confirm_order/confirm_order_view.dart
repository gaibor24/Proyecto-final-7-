import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import 'confirm_content.dart';

class ConfirmOrderView extends StatelessWidget {
  const ConfirmOrderView({
    super.key,
    required this.total,
    required this.quantity,
  });

  final double total;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => CartController(),
        child: ConfirmContent(total: total, quantity: quantity),
      ),
    );
  }
}
