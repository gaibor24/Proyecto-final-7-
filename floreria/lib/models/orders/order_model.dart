import '../products/product_item_model.dart';
import '../user/user_model.dart';
import 'order_item_model.dart';

class OrderModel {
  final UserModel? user;
  final List<OrderItemModel> orders;
  final OrderItemModel? order;
  final List<ProductItemModel> items;

  OrderModel({
    this.user,
    required this.orders,
    this.order,
    required this.items,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      orders: List<OrderItemModel>.from(
        ((map['orders'] ?? []) as List).map((x) => OrderItemModel.fromMap(x)),
      ),
      order: map['order'] != null ? OrderItemModel.fromMap(map['order']) : null,
      items: List<ProductItemModel>.from(
        ((map['items'] ?? []) as List).map((x) => ProductItemModel.fromMap(x)),
      ),
    );
  }
}
