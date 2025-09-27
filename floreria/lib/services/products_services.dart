import 'dart:io';

import '../models/api_model.dart';
import '../models/products/product_model.dart';
import 'api_services.dart';

class ProductsServices {
  Future<ApiModel<ProductModel>> getProducts({String search = ''}) async {
    final response = await ApiServices.request(
      endpoint: 'products',
      method: HttpMethod.get,
      params: {'search': search},
      fromJson: (data) {
        final dt = ProductModel.fromMap(data);
        return dt;
      },
    );

    return response;
  }

  Future<ApiModel<bool>> addProduct({
    required String name,
    required String description,
    required double price,
    required double discountPrice,
    required String category,
    File? image,
  }) async {
    final map = {
      'name': name,
      'description': description,
      'price': price.toString(),
      'discount_price': discountPrice.toString(),
      'category': category,
    };

    final response = await ApiServices.request(
      endpoint: 'products/add/',
      method: HttpMethod.post,
      body: map,
      file: image,
      fromJson: (_) => true,
    );

    return response;
  }

  Future<ApiModel<ProductModel>> editProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required double discountPrice,
    required String category,
    File? image,
  }) async {
    final map = {
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'category': category,
    };

    final response = await ApiServices.request(
      endpoint: 'products/update/$productId',
      method: HttpMethod.put,
      body: map,
      file: image,
      fromJson: (data) {
        final dt = ProductModel.fromMap(data);
        return dt;
      },
    );

    return response;
  }

  Future<ApiModel<bool>> removeProduct({required String productId}) async {
    final response = await ApiServices.request(
      endpoint: 'products/remove/$productId',
      method: HttpMethod.delete,
      fromJson: (data) {
        return true;
      },
    );

    return response;
  }
}
