import 'dart:convert';

List<CartItem> cartItemFromJson(String str) => List<CartItem>.from(json.decode(str).map((x) => CartItem.fromJson(x)));

String cartItemToJson(List<CartItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartItem {
  final String productId;
  final String userId;
  final int quantity;
  final String selectedVariant;
  final String id;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String createdById;
  final String createdBy;
  final bool isSample;

  CartItem({
    required this.productId,
    required this.userId,
    required this.quantity,
    required this.selectedVariant,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.createdById,
    required this.createdBy,
    required this.isSample,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json["product_id"],
    userId: json["user_id"],
    quantity: json["quantity"],
    selectedVariant: json["selected_variant"],
    id: json["id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    createdById: json["created_by_id"],
    createdBy: json["created_by"],
    isSample: json["is_sample"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "user_id": userId,
    "quantity": quantity,
    "selected_variant": selectedVariant,
    "id": id,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "created_by_id": createdById,
    "created_by": createdBy,
    "is_sample": isSample,
  };
}
