// ignore_for_file: use_build_context_synchronously

import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_controller.dart';
import '../../themes/texts_style.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/strings_utils.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_image_cache.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/quantity_counter.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item, this.isOnTap = true});

  final ProductItemModel item;
  final bool isOnTap;

  double get price {
    if (item.discountPrice > 0) {
      return item.discountPrice;
    }

    return item.price;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      isShadow: true,
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageCache(url: item.imageUrl, height: 60, width: 60),
          Expanded(
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isOnTap)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomCard(
                      height: 25,
                      width: 25,
                      onTap: () async {
                        final cubit = context.read<CartController>();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const DialogLoading(),
                        );

                        final value = await cubit.removeItemCart(
                          productId: item.id,
                        );

                        if (value.isEmpty) {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);

                            await SnackBarUtils.snackBarGeneric(
                              context,
                              value: 'Se ha removido el producto de su carrito',
                            );
                          }
                        } else {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);

                            await SnackBarUtils.snackBarGeneric(
                              context,
                              value: value,
                            );
                          }
                        }
                      },
                      child: Center(
                        child: Icon(Icons.close, size: 16, color: Colors.grey),
                      ),
                    ),
                  ),

                Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextsStyle(context).bodySmall,
                    ),

                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextsStyle(context).bodyMedium,
                    ),
                  ],
                ),

                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextsStyle(context).bodyMedium,
                  ),

                if (!isOnTap)
                  Text(
                    'Cantidad: ${item.quantity}',
                    style: TextsStyle(context).bodyMedium,
                  ),

                SizedBox(height: 7),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.discountPrice > 0)
                          Text(
                            StringsUtils.moneyFormat(item.price),
                            style: TextsStyle(context).bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          StringsUtils.moneyFormat(price),
                          style: TextsStyle(
                            context,
                          ).bodyMedium.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    if (!isOnTap)
                      Text(
                        StringsUtils.moneyFormat(item.subtotal),
                        style: TextsStyle(
                          context,
                        ).titleMedium.copyWith(fontSize: 16),
                      ),
                    if (isOnTap)
                      QuantityCounter(
                        max: 100,
                        initialValue: item.quantity,
                        sizeButton: 35,
                        sizeWidth: 50,
                        onChanged: (quantity, message) async {
                          final cubit = context.read<CartController>();

                          if (message == null) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const DialogLoading(),
                            );

                            final value = await cubit.changeQuantity(
                              productId: item.id,
                              quantity: quantity,
                            );

                            if (value.isEmpty) {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            } else {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);

                                await SnackBarUtils.snackBarGeneric(
                                  context,
                                  value: value,
                                );
                              }
                            }
                          } else {
                            await SnackBarUtils.snackBarGeneric(
                              context,
                              value: message,
                            );
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
