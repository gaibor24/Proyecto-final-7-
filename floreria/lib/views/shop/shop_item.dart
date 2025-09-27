import 'package:flutter/material.dart';

import '../../colors/app_colors.dart';
import '../../models/products/product_item_model.dart';
import '../../themes/texts_style.dart';
import '../../utils/strings_utils.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_image_cache.dart';
import '../product_details/product_details_view.dart';

class ShopItem extends StatelessWidget {
  const ShopItem({super.key, required this.item});

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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductDetailsView(product: item, isAdmin: false);
                },
              ),
            );
          },
          child: Column(
            spacing: 10,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    CustomCard(
                      backgroundColor: AppColors.grisSuave,
                      child: Center(
                        child: CustomImageCache(
                          url: item.imageUrl,
                          width: (width) * 0.7,
                          height: (height - 150) * 0.7,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      right: 7,
                      child: CustomCard(
                        width: 30,
                        height: 30,
                        borderRadius: 11,
                        onTap: () {},
                        backgroundColor: Colors.black,
                        child: Icon(Icons.favorite_border, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
