import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../controllers/product_controller.dart';
import 'product_details_content.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.product,
    required this.isAdmin,
  });

  final ProductItemModel product;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => ProductController(),
        child: SafeArea(
          top: false,
          child: Container(
            color: AppColors.grisSuave,
            child: Column(
              children: [
                AppBar(title: Text('Detalles del producto')),
                Expanded(
                  child: ProductDetailsContent(
                    product: product,
                    isAdmin: isAdmin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
