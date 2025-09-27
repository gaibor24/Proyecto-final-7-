import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';

import '../services/cart_services.dart';

class ProductController with ChangeNotifier {
  final _services = CartServices();

  ProductItemModel? _product;
  ProductItemModel? get product => _product;

  int _quantity = 1;
  int get quantity => _quantity;

  Future<void> getProduct(ProductItemModel item) async {
    _product = item;
    notifyListeners();
  }

  Future<void> changeQuantity(int value) async {
    _quantity = value;
    notifyListeners();
  }

  Future<String> addProduct() async {
    final response = await _services.addCart(
      productId: product?.id ?? '',
      quantity: quantity,
    );

    if (response.success) {
      return '';
    } else {
      return response.message;
    }
  }
}
