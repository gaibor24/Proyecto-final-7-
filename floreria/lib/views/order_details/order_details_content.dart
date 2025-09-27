// ignore_for_file: use_build_context_synchronously

import 'package:floreria/models/orders/order_item_model.dart';
import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_details_controller.dart';
import '../../status/status_page_value.dart';
import '../../themes/themes.dart';
import '../../utils/strings_utils.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/handler_error.dart';
import '../cart/cart_item.dart';

class OrderDetailsContent extends StatefulWidget {
  const OrderDetailsContent({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<OrderDetailsContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<OrderDetailsController>(
        context,
        listen: false,
      ).getOrderDetails(widget.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OrderDetailsController>(context);

    return Builder(
      builder: (context) {
        switch (controller.status) {
          case StatusPage.loading:
            return const Center(child: CircularProgressIndicator());

          case StatusPage.errorConnection:
            return HandlerError(
              icon: Icons.wifi_off,
              text: "No tienes conexión a internet",
              onRetry: () {
                controller.getOrderDetails(widget.orderId);
              },
            );

          case StatusPage.errorBackend:
            return HandlerError(
              icon: Icons.cloud_off,
              text: "Error en el servidor, intenta más tarde",
              onRetry: () {
                controller.getOrderDetails(widget.orderId);
              },
            );

          case StatusPage.errorApp:
            return HandlerError(
              icon: Icons.bug_report_outlined,
              text: "Error interno en la aplicación",
              onRetry: () {
                controller.getOrderDetails(widget.orderId);
              },
            );

          case StatusPage.success:
            return controller.order != null
                ? _Body(
                  order: controller.order!.order!,
                  items: controller.order!.items,
                )
                : SizedBox.shrink();

          default:
            return SizedBox.shrink();
        }
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.items, required this.order});

  final OrderItemModel order;
  final List<ProductItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            padding: EdgeInsets.all(20),
            separatorBuilder: (_, i) => SizedBox(height: 15),
            itemBuilder: (_, i) {
              return CartItem(item: items[i], isOnTap: false);
            },
          ),
        ),
        CustomCard(
          isShadow: true,
          padding: EdgeInsets.all(15),
          child: Column(
            spacing: 7,
            children: [
              _text(
                context,
                title: 'Subtotal',
                value: double.tryParse((order.subtotal).toString()) ?? 0,
              ),
              _text(
                context,
                title: 'Descuento',
                color: Colors.red,
                value: double.tryParse((order.discount).toString()) ?? 0,
              ),
              _text(
                context,
                title: 'Envio',
                value: double.tryParse((order.shipping).toString()) ?? 0,
              ),
              _text(
                context,
                title: 'Total',
                value: double.tryParse((order.grandTotal).toString()) ?? 0,
                isBold: true,
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
