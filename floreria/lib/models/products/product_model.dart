import 'product_item_model.dart';

class ProductModel {
  final List<ProductItemModel> products;

  ProductModel({required this.products});

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      products: List<ProductItemModel>.from(
        ((map['products'] ?? []) as List).map((e) {
          return ProductItemModel.fromMap(e);
        }),
      ),
    );
  }
}
