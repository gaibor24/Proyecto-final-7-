// ignore_for_file: deprecated_member_use

import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';

import 'home_item_product.dart';

class HomeListProduct extends StatelessWidget {
  const HomeListProduct({super.key, required this.list, required this.isAdmin});

  final List<ProductItemModel> list;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 20,
        childAspectRatio: 0.5,
      ),
      itemBuilder: (_, i) {
        final item = list[i];

        return HomeItemProduct(item: item);
      },
    );
  }
}
