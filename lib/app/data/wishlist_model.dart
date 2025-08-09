import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
  final String productId;
  final String userId;
  final String id;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String createdById;
  final String createdBy;
  final bool isSample;

  Wishlist({
    required this.productId,
    required this.userId,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.createdById,
    required this.createdBy,
    required this.isSample,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    productId: json["product_id"],
    userId: json["user_id"],
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
    "id": id,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "created_by_id": createdById,
    "created_by": createdBy,
    "is_sample": isSample,
  };
}
