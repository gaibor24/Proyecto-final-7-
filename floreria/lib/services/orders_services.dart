import 'package:floreria/services/api_services.dart';

import '../models/api_model.dart';
import '../models/orders/order_model.dart';

class OrdersServices {
  Future<ApiModel<bool>> confirmOrder({
    required String city,
    required String province,
    required String reference,
    required String phoneNumber,
  }) async {
    final response = await ApiServices.request(
      endpoint: 'orders/confirm/',
      method: HttpMethod.post,
      body: {
        'city': city,
        'province': province,
        'reference': reference,
        'phone_number': phoneNumber,
      },
      fromJson: (data) {
        return true;
      },
    );

    return response;
  }

  Future<ApiModel<OrderModel>> getOrders() async {
    final response = await ApiServices.request(
      endpoint: 'orders',
      method: HttpMethod.get,
      fromJson: (data) {
        return OrderModel.fromMap(data);
      },
    );

    return response;
  }

  Future<ApiModel<OrderModel>> getOrderDetails({
    required String orderId,
  }) async {
    final response = await ApiServices.request(
      endpoint: 'orders/$orderId',
      method: HttpMethod.get,
      fromJson: (data) {
        return OrderModel.fromMap(data);
      },
    );

    return response;
  }
}
