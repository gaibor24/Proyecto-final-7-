import 'package:floreria/models/api_model.dart';

import '../models/cart/cart_model.dart';
import 'api_services.dart';

class CartServices {
  Future<ApiModel<CartModel>> getCart() async {
    final response = await ApiServices.request(
      endpoint: 'cart',
      method: HttpMethod.get,
      fromJson: (data) {
        return CartModel.fromMap(data);
      },
    );

    return response;
  }

  Future<ApiModel<bool>> addCart({
    required String productId,
    required int quantity,
  }) async {
    final response = await ApiServices.request(
      endpoint: 'cart/add/',
      method: HttpMethod.post,
      body: {'product_id': productId, 'quantity': quantity},
      fromJson: (data) {
        return true;
      },
    );

    return response;
  }

  Future<ApiModel<bool>> removeItemCart({required String productId}) async {
    final response = await ApiServices.request(
      endpoint: 'cart/remove',
      method: HttpMethod.delete,
      body: {'product_id': productId},
      fromJson: (data) {
        return true;
      },
    );

    return response;
  }

  Future<ApiModel<bool>> changeQuantity({
    required String productId,
    required int quantity,
  }) async {
    final response = await ApiServices.request(
      endpoint: 'cart/update/$productId/',
      method: HttpMethod.put,
      body: {'quantity': quantity},
      fromJson: (data) {
        return true;
      },
    );

    return response;
  }
}
