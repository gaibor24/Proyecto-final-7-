// ignore_for_file: use_build_context_synchronously

import 'package:floreria/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import '../../models/cart/cart_model.dart';
import '../../themes/texts_style.dart';
import '../../utils/strings_utils.dart';
import '../../widgets/custom_card.dart';
import '../confirm_order/confirm_order_view.dart';
import 'cart_item.dart';

class CartContent extends StatefulWidget {
  const CartContent({super.key});

  @override
  State<CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<CartController>(context, listen: false).getCart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CartController>(context);

    return Builder(
      builder: (context) {
        if (controller.cart != null) {
          return _Body(cart: controller.cart!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: cart.items.length,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            separatorBuilder: (_, i) => SizedBox(height: 15),
            itemBuilder: (_, i) {
              return CartItem(item: cart.items[i]);
            },
          ),
        ),
        CustomCard(
          isShadow: true,
          padding: EdgeInsets.all(10),
          child: Column(
            spacing: 8,
            children: [
              _text(context, title: 'Subtotal', value: cart.subtotal),
              _text(
                context,
                title: 'Descuento',
                value: cart.discount,
                color: Colors.red,
              ),
              _text(context, title: 'Impuestos', value: cart.tax),
              _text(context, title: 'Envío', value: cart.shipping),
              _text(
                context,
                title: 'Total',
                value: cart.grandTotal,
                isBold: true,
              ),
              CustomButton(
                width: size.width,
                value: 'Confirmar pedido',
                isOnTap: cart.items.isNotEmpty,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ConfirmOrderView(
                            quantity: cart.items.length,
                            total: cart.grandTotal,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _text(
    BuildContext context, {
    required String title,
    required double value,
    Color? color,
    bool isBold = false,
  }) {
    String price = StringsUtils.moneyFormat(value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              isBold
                  ? TextsStyle(context).titleSmall
                  : TextsStyle(context).bodySmall.copyWith(color: color),
        ),
        Text(
          color == Colors.red ? '-$price' : price,
          style:
              isBold
                  ? TextsStyle(context).titleMedium.copyWith(fontSize: 18)
                  : TextsStyle(context).bodyMedium.copyWith(color: color),
        ),
      ],
    );
  }
}
