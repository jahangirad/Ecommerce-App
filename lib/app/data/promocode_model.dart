import 'dart:convert';

List<PromoCode> promoCodeFromJson(String str) => List<PromoCode>.from(json.decode(str).map((x) => PromoCode.fromJson(x)));

String promoCodeToJson(List<PromoCode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PromoCode {
  final String code;
  final String description;
  final String discountType;
  final int discountValue;
  final int minimumOrder;
  final DateTime expiryDate;
  final bool isActive;
  final int usageLimit;
  final int usedCount;
  final String id;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String createdById;
  final String createdBy;
  final bool isSample;

  PromoCode({
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minimumOrder,
    required this.expiryDate,
    required this.isActive,
    required this.usageLimit,
    required this.usedCount,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.createdById,
    required this.createdBy,
    required this.isSample,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
    code: json["code"],
    description: json["description"],
    discountType: json["discount_type"],
    discountValue: json["discount_value"],
    minimumOrder: json["minimum_order"],
    expiryDate: DateTime.parse(json["expiry_date"]),
    isActive: json["is_active"],
    usageLimit: json["usage_limit"],
    usedCount: json["used_count"],
    id: json["id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    createdById: json["created_by_id"],
    createdBy: json["created_by"],
    isSample: json["is_sample"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": description,
    "discount_type": discountType,
    "discount_value": discountValue,
    "minimum_order": minimumOrder,
    "expiry_date": "${expiryDate.year.toString().padLeft(4, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}",
    "is_active": isActive,
    "usage_limit": usageLimit,
    "used_count": usedCount,
    "id": id,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "created_by_id": createdById,
    "created_by": createdBy,
    "is_sample": isSample,
  };
}
