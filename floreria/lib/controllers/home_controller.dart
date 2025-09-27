import 'package:flutter/material.dart';

import '../models/products/product_item_model.dart';
import '../services/products_services.dart';
import '../status/status_page_value.dart';

class HomeController with ChangeNotifier {
  final _service = ProductsServices();

  StatusPage _statusList = StatusPage.initial;
  StatusPage get statusList => _statusList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ProductItemModel> _products = [];
  List<ProductItemModel> get products => _products;

  Future<void> getProducts({String search = ''}) async {
    _statusList = StatusPage.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getProducts(search: search);

    if (response.success) {
      final data = response.data;

      _products = data?.products ?? [];
      _statusList = _products.isEmpty ? StatusPage.empty : StatusPage.success;
    } else {
      _statusList = StatusPage.errorApp;
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<String> removeProduct(String id) async {
    final response = await _service.removeProduct(productId: id);

    if (response.success) {
      final res = await _service.getProducts();

      if (res.success) {
        final data = res.data;
        _products = data?.products ?? [];
        _statusList = _products.isEmpty ? StatusPage.empty : StatusPage.success;
        notifyListeners();
        return '';
      } else {
        return res.message;
      }
    } else {
      return response.message;
    }
  }

  Future<void> clearList() async {
    _products = [];
    notifyListeners();
  }
}
