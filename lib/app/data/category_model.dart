import 'dart:convert';

List<Category> categoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  final String name;
  final String slug;
  final String description;
  final String image;
  final dynamic parentCategory;
  final bool isFeatured;
  final String id;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String createdById;
  final String createdBy;
  final bool isSample;

  Category({
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.parentCategory,
    required this.isFeatured,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.createdById,
    required this.createdBy,
    required this.isSample,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    image: json["image"],
    parentCategory: json["parent_category"],
    isFeatured: json["is_featured"],
    id: json["id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    createdById: json["created_by_id"],
    createdBy: json["created_by"],
    isSample: json["is_sample"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "description": description,
    "image": image,
    "parent_category": parentCategory,
    "is_featured": isFeatured,
    "id": id,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "created_by_id": createdById,
    "created_by": createdBy,
    "is_sample": isSample,
  };
}
