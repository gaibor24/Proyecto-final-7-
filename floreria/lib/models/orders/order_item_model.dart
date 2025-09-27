import '../user/user_model.dart';

class OrderItemModel {
  final String id;
  final UserModel? user;
  final double totalAmount;
  final String status;
  final String createdAt;
  final double subtotal;
  final double discount;
  final double shipping;
  final double grandTotal;

  OrderItemModel({
    required this.id,
    this.user,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.grandTotal,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] ?? '',
      totalAmount:
          (map['total_amount'] is num)
              ? (map['total_amount'] as num).toDouble()
              : 0.0,
      status: map['status'] ?? '',
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      createdAt: map['created_at'] ?? '',
      discount:
          (map['discount'] is num) ? (map['discount'] as num).toDouble() : 0.0,
      subtotal:
          (map['subtotal'] is num) ? (map['subtotal'] as num).toDouble() : 0.0,
      shipping:
          (map['shipping'] is num) ? (map['shipping'] as num).toDouble() : 0.0,
      grandTotal:
          (map['grand_total'] is num)
              ? (map['grand_total'] as num).toDouble()
              : 0.0,
    );
  }
}
