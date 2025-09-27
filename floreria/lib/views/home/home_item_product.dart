// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:floreria/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../../models/products/product_item_model.dart';
import '../../themes/texts_style.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/strings_utils.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_image_cache.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/mini_button.dart';
import '../add_product/add_product_view.dart';

class HomeItemProduct extends StatelessWidget {
  const HomeItemProduct({super.key, required this.item});

  final ProductItemModel item;

  double get price {
    if (item.discountPrice > 0) {
      return item.discountPrice;
    }

    return item.price;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth;
        final height = c.maxHeight;
        return Column(
          spacing: 10,
          children: [
            Expanded(
              child: CustomCard(
                backgroundColor: AppColors.grisSuave,
                child: Center(
                  child: CustomImageCache(
                    url: item.imageUrl,
                    width: (width) * 0.7,
                    height: (height - 150) * 0.7,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        item.category.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextsStyle(
                          context,
                        ).bodySmall.copyWith(color: AppColors.grisBorder),
                      ),
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextsStyle(context).bodyMedium,
                      ),
                      SizedBox(),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextsStyle(
                          context,
                        ).bodySmall.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.discountPrice > 0)
                          Text(
                            StringsUtils.moneyFormat(item.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextsStyle(context).bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          StringsUtils.moneyFormat(price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextsStyle(
                            context,
                          ).titleMedium.copyWith(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 7,
                    children: [
                      /* Expanded(
                        child: MiniButton(
                          value: 'Eliminar',
                          backgroundColor: Colors.redAccent,
                          onTap: () async {
                            
                          },
                        ),
                      ), */
                      CustomCard(
                        width: 40,
                        height: 40,
                        isShadow: true,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        ),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return CustomDialog(
                                title: 'Eliminar producto',
                                subContent:
                                    '¿Estás seguro de que deseas eliminar este producto? Esta acción no se puede deshacer',
                                onAccept: () async {
                                  final cubit = context.read<HomeController>();

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const DialogLoading(),
                                  );

                                  final value = await cubit.removeProduct(
                                    item.id,
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
                                },
                              );
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: MiniButton(
                          heightButton: 35,
                          value: 'Editar',
                          icon: Icons.edit,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AddProductView(product: item);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/* class InvertedDiagonalClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double cutPercent;

  InvertedDiagonalClipper({this.borderRadius = 16, this.cutPercent = 0.3});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Punto inicial: (0, altura*cutPercent) → recorte desde 30% hacia abajo
    path.moveTo(0, size.height * cutPercent);

    // Línea hacia topRight con esquina redondeada
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Línea hacia bottomRight con esquina redondeada
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - borderRadius,
      size.height,
    );

    // Línea hacia bottomLeft con esquina redondeada
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);

    // Línea de cierre hacia (0, altura*cutPercent)
    path.lineTo(0, size.height * cutPercent);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
} */
