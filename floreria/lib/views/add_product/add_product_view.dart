import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/add_product_controller.dart';
import '../../models/products/product_item_model.dart';
import 'add_product_content.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key, this.product});

  final ProductItemModel? product;

  String get title {
    if (product != null) {
      return 'Editar producto';
    } else {
      return 'Agregar producto';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ChangeNotifierProvider(
        create: (context) => AddProductController()..setProduct(product),
        child: AddProductContent(product: product),
      ),
    );
  }
}
