import 'package:floreria/models/orders/order_model.dart';
import 'package:flutter/material.dart';

import '../services/orders_services.dart';
import '../status/status_page_value.dart';

class OrderDetailsController with ChangeNotifier {
  final _service = OrdersServices();

  OrderModel? _order;
  OrderModel? get order => _order;

  StatusPage _status = StatusPage.initial;
  StatusPage get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getOrderDetails(String orderId) async {
    _status = StatusPage.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _service.getOrderDetails(orderId: orderId);

    if (response.success) {
      final data = response.data;
      _order = data;
      _status = StatusPage.success;
    } else {
      _status = StatusPage.errorApp;
      _errorMessage = response.message;
    }

    notifyListeners();
  }
}
