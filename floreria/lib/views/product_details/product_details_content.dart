// ignore_for_file: use_build_context_synchronously

import 'package:floreria/models/products/product_item_model.dart';
import 'package:floreria/widgets/custom_card.dart';
import 'package:floreria/widgets/custom_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../controllers/product_controller.dart';
import '../../themes/texts_style.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/quantity_counter.dart';

class ProductDetailsContent extends StatefulWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.isAdmin,
  });

  final ProductItemModel product;
  final bool isAdmin;

  @override
  State<ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<ProductDetailsContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<ProductController>(
        context,
        listen: false,
      ).getProduct(widget.product),
    );
  }

  double get price {
    if (widget.product.discountPrice > 0) {
      return widget.product.discountPrice;
    }

    return widget.product.price;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = context.read<ProductController>();

    return SizedBox(
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: size.width,
            height: size.height * 0.55,
            child: CustomCard(
              isShadow: true,
              backgroundColor: Colors.white,
              radius: BorderRadius.vertical(top: Radius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: size.height * 0.02),
                  Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.product.category.toUpperCase(),
                        style: TextsStyle(
                          context,
                        ).bodySmall.copyWith(color: Colors.grey),
                      ),
                      Text(
                        widget.product.name,
                        style: TextsStyle(context).titleMedium,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.product.description,
                        style: TextsStyle(
                          context,
                        ).bodyMedium.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                  Center(
                    child: QuantityCounter(
                      max: 20,
                      min: 1,
                      onChanged: (int value, String? errorMessage) async {
                        if (errorMessage != null) {
                          await SnackBarUtils.snackBarGeneric(
                            context,
                            value: errorMessage,
                          );
                        } else {
                          await context
                              .read<ProductController>()
                              .changeQuantity(value);
                        }
                      },
                    ),
                  ),
                  Center(
                    child: CustomButton(
                      icon: Icons.add,
                      width: size.width,
                      value: 'Añadir al carrito',
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const DialogLoading(),
                        );

                        final value = await cubit.addProduct();

                        if (value.isEmpty) {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);

                            await SnackBarUtils.snackBarGeneric(
                              context,
                              value: 'Producto agregado al carrito',
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
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, size.height * 0.02),
              child: CustomImageCache(
                url: widget.product.imageUrl,
                height: size.height * 0.35,
              ),
            ),
          ),
        ],
      ),
    );

    /* return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 7,
        children: [
          Center(
            child: Text(
              widget.product.category.toUpperCase(),
              style: TextsStyle(context).bodySmall.copyWith(color: Colors.grey),
            ),
          ),
          Center(
            child: Text(
              widget.product.name,
              style: TextsStyle(context).titleMedium,
            ),
          ),
          SizedBox(),
          Center(
            child: CustomImageCache(
              url: widget.product.imageUrl,
              width: size.width * 0.5,
              height: size.width * 0.5,
            ),
          ),
          SizedBox(),
          Column(
            spacing: 5,
            children: [
              if (widget.product.discountPrice > 0)
                Text(
                  '\$${widget.product.price}',
                  style: TextsStyle(context).bodyMedium.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              Text('\$$price', style: TextsStyle(context).titleMedium),
            ],
          ),
          Text(
            widget.product.description,
            style: TextsStyle(context).bodyMedium,
          ),
          SizedBox(height: 20),
          QuantityCounter(
            max: 20,
            min: 1,
            onChanged: (int value, String? errorMessage) async {
              if (errorMessage != null) {
                await SnackBarUtils.snackBarGeneric(
                  context,
                  value: errorMessage,
                );
              } else {
                await context.read<ProductController>().changeQuantity(value);
              }
            },
          ),
          SizedBox(height: 20),
          CustomButton(
            width: size.width,
            value: 'Agregar al carrito',
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const DialogLoading(),
              );

              final value = await cubit.addProduct();

              if (value.isEmpty) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);

                  await SnackBarUtils.snackBarGeneric(
                    context,
                    value: 'Producto agregado al carrito',
                  );
                }
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);

                  await SnackBarUtils.snackBarGeneric(context, value: value);
                }
              }
            },
          ),
        ],
      ),
    ); */
  }
}
