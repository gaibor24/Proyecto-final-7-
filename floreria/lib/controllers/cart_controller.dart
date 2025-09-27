import 'package:flutter/material.dart';

import '../models/cart/cart_model.dart';
import '../services/cart_services.dart';
import '../services/orders_services.dart';
import '../status/status_page_value.dart';

class CartController with ChangeNotifier {
  final _service = CartServices();
  final _orderService = OrdersServices();

  StatusPage _status = StatusPage.initial;
  StatusPage get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CartModel? _cart;
  CartModel? get cart => _cart;

  Future<void> getCart() async {
    _status = StatusPage.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getCart();

    if (response.success) {
      final data = response.data;
      _cart = data;
      _status = StatusPage.success;
    } else {
      _status = StatusPage.errorApp;
      _errorMessage = response.message;
    }

    notifyListeners();
  }

  Future<String> removeItemCart({required String productId}) async {
    final response = await _service.removeItemCart(productId: productId);

    if (response.success) {
      final res = await _service.getCart();

      if (res.success) {
        final data = res.data;
        _cart = data;
        notifyListeners();
        return '';
      } else {
        return 'Hubo un error al actualizar los productos';
      }
    } else {
      return response.message;
    }
  }

  Future<String> changeQuantity({
    required String productId,
    required int quantity,
  }) async {
    final response = await _service.changeQuantity(
      productId: productId,
      quantity: quantity,
    );

    if (response.success) {
      final res = await _service.getCart();

      if (res.success) {
        final data = res.data;
        _cart = data;
        notifyListeners();
        return '';
      } else {
        return 'Hubo un error al actualizar los productos';
      }
    } else {
      return response.message;
    }
  }

  Future<String> confirmOrder({
    required String city,
    required String province,
    required String reference,
    required String phoneNumber,
  }) async {
    final response = await _orderService.confirmOrder(
      city: city,
      province: province,
      reference: reference,
      phoneNumber: phoneNumber,
    );

    if (response.success) {
      return '';
    } else {
      return response.message;
    }
  }
}
