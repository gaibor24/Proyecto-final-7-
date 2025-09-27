import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import 'cart_content.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (content) => CartController(),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AppBar(title: Text('Mi Carrito')),
              Expanded(child: CartContent()),
            ],
          ),
        ),
      ),
    );
  }
}
