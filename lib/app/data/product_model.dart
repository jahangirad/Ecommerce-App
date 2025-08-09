import 'dart:convert';

List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String category;
  final String brand;
  final List<String> images;
  final int stockCount;
  final double rating;
  final int reviewsCount;
  final dynamic specifications;
  final bool isFeatured;
  final bool isOnSale;
  final String id;
  final DateTime createdDate;
  final DateTime updatedDate;
  final CreatedById createdById;
  final CreatedBy createdBy;
  final bool isSample;

  Products({
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.brand,
    required this.images,
    required this.stockCount,
    required this.rating,
    required this.reviewsCount,
    required this.specifications,
    required this.isFeatured,
    required this.isOnSale,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.createdById,
    required this.createdBy,
    required this.isSample,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    name: json["name"],
    description: json["description"],
    price: json["price"]?.toDouble(),
    originalPrice: json["original_price"]?.toDouble(),
    category: json["category"],
    brand: json["brand"],
    images: List<String>.from(json["images"].map((x) => x)),
    stockCount: json["stock_count"],
    rating: json["rating"]?.toDouble(),
    reviewsCount: json["reviews_count"],
    specifications: json["specifications"],
    isFeatured: json["is_featured"],
    isOnSale: json["is_on_sale"],
    id: json["id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    createdById: createdByIdValues.map[json["created_by_id"]]!,
    createdBy: createdByValues.map[json["created_by"]]!,
    isSample: json["is_sample"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "original_price": originalPrice,
    "category": category,
    "brand": brand,
    "images": List<dynamic>.from(images.map((x) => x)),
    "stock_count": stockCount,
    "rating": rating,
    "reviews_count": reviewsCount,
    "specifications": specifications,
    "is_featured": isFeatured,
    "is_on_sale": isOnSale,
    "id": id,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "created_by_id": createdByIdValues.reverse[createdById],
    "created_by": createdByValues.reverse[createdBy],
    "is_sample": isSample,
  };
}

enum CreatedBy {
  PONIRA4206_ARAVITES_COM
}

final createdByValues = EnumValues({
  "ponira4206@aravites.com": CreatedBy.PONIRA4206_ARAVITES_COM
});

enum CreatedById {
  THE_68974_F11_CD1_AC74_DDD5_A9_BC1
}

final createdByIdValues = EnumValues({
  "68974f11cd1ac74ddd5a9bc1": CreatedById.THE_68974_F11_CD1_AC74_DDD5_A9_BC1
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
