import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  final String userId;
  final String orderNumber;
  final String status;
  final List<Item> items;
  final double subtotal;
  final int shippingCost;
  final double totalAmount;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final String id;
  final DateTime createdDate;
  final DateTime updatedDate;
  final String createdById;
  final String createdBy;
  final bool isSample;

  Order({
    required this.userId,
    required this.orderNumber,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.createdById,
    required this.createdBy,
    required this.isSample,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    userId: json["user_id"],
    orderNumber: json["order_number"],
    status: json["status"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    subtotal: json["subtotal"]?.toDouble(),
    shippingCost: json["shipping_cost"],
    totalAmount: json["total_amount"]?.toDouble(),
    shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
    paymentMethod: json["payment_method"],
    id: json["id"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    createdById: json["created_by_id"],
    createdBy: json["created_by"],
    isSample: json["is_sample"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "order_number": orderNumber,
    "status": status,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "subtotal": subtotal,
    "shipping_cost": shippingCost,
    "total_amount": totalAmount,
    "shipping_address": shippingAddress.toJson(),
    "payment_method": paymentMethod,
    "id": id,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "created_by_id": createdById,
    "created_by": createdBy,
    "is_sample": isSample,
  };
}

class Item {
  final String productId;
  final dynamic name;
  final double price;
  final int quantity;
  final dynamic image;

  Item({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["product_id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    quantity: json["quantity"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "name": name,
    "price": price,
    "quantity": quantity,
    "image": image,
  };
}

class ShippingAddress {
  final dynamic fullName;
  final dynamic addressLine1;
  final dynamic addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ShippingAddress({
    required this.fullName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    fullName: json["full_name"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postal_code"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "country": country,
  };
}
