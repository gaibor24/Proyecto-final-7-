import 'package:floreria/models/products/product_item_model.dart';

class CartModel {
  final List<ProductItemModel> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double shipping;
  final double grandTotal;
  final String currency;

  CartModel({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.shipping,
    required this.grandTotal,
    required this.currency,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      items: List<ProductItemModel>.from(
        ((map['items'] ?? []) as List).map((x) => ProductItemModel.fromMap(x)),
      ),
      subtotal: double.tryParse((map['subtotal'] ?? 0.0).toString()) ?? 0,
      discount: double.tryParse((map['discount'] ?? 0.0).toString()) ?? 0,
      tax: double.tryParse((map['tax'] ?? 0.0).toString()) ?? 0,
      shipping: double.tryParse((map['shipping'] ?? 0.0).toString()) ?? 0,
      grandTotal: double.tryParse((map['grand_total'] ?? 0.0).toString()) ?? 0,
      currency: map['currency'] ?? 'USD',
    );
  }
}
