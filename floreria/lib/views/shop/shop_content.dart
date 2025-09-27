// ignore_for_file: deprecated_member_use

import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';

import '../../constants/icons_constants.dart';
import '../../themes/texts_style.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_image_cache.dart';
import '../search/search_view.dart';
import 'shop_item.dart';

class ShopContent extends StatelessWidget {
  const ShopContent({super.key, required this.list});

  final List<ProductItemModel> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCard(
          height: 45,
          isShadow: true,
          width: MediaQuery.of(context).size.width - 30,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SearchView();
                },
              ),
            );
          },
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageCache(
                url: IconsConstants.search,
                height: 20,
                width: 20,
                imageColor: Colors.grey,
              ),
              Text('Buscar producto', style: TextsStyle(context).hint),
            ],
          ),
        ),
        SizedBox(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('Productos', style: TextsStyle(context).bodyLarge),
          ),
        ),
        GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 20,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (_, i) {
            final item = list[i];

            return ShopItem(item: item);
          },
        ),
      ],
    );
  }
}
