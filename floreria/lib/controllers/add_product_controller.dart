import 'dart:io';

import 'package:floreria/models/products/product_item_model.dart';
import 'package:flutter/material.dart';

import '../services/products_services.dart';

class AddProductController with ChangeNotifier {
  final _service = ProductsServices();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _name = '';
  String get name => _name;

  String _category = '';
  String get category => _category;

  String _price = '';
  String get price => _price;

  String _discountPrice = '';
  String get discountPrice => _discountPrice;

  String _description = '';
  String get description => _description;

  void onChangeName(String value) {
    _name = value;
    notifyListeners();
  }

  void onChangeCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void onChangePrice(String value) {
    _price = value;
    notifyListeners();
  }

  void onChangeDiscountPrice(String value) {
    _discountPrice = value;
    notifyListeners();
  }

  void onChangeDescription(String value) {
    _description = value;
    notifyListeners();
  }

  Future<String> addProduct({
    required bool isProduct,
    required String productId,
    File? image,
  }) async {
    if (!isProduct) {
      final response = await _service.addProduct(
        name: name,
        description: description,
        price: double.tryParse(price.toString()) ?? 0,
        discountPrice: double.tryParse(discountPrice.toString()) ?? 0,
        category: category,
        image: image,
      );

      if (response.success) {
        return '';
      } else {
        return response.message;
      }
    } else {
      final response = await _service.editProduct(
        productId: productId,
        name: name,
        description: description,
        price: double.tryParse(price.toString()) ?? 0,
        discountPrice: double.tryParse(discountPrice.toString()) ?? 0,
        category: category,
        image: image,
      );

      if (response.success) {
        return '';
      } else {
        return response.message;
      }
    }
  }

  void setProduct(ProductItemModel? product) {
    _name = product?.name ?? '';
    _price = (product?.price ?? '').toString();
    _category = product?.category ?? '';
    _discountPrice = (product?.discountPrice ?? '').toString();
    _description = product?.description ?? '';
    notifyListeners();
  }
}
