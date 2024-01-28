import 'dart:convert';

// model reflecting product table in database
class Product {
  String name;
  String productId;
  double price;
  int quantity;
  final String id;

  // Constructor to initialize a Product with required attributes
  Product({
    required this.name,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.id,
  });

  // Method to convert the Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'productId': productId,
      'price': price,
      'quantity': quantity,
      'id': id,
    };
  }

  // Factory method to create a Product object from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      productId: map['productId'],
      price: map['price']?.toDouble(),
      quantity: map['quantity']?.toInt(),
      id: map['id'],
    );
  }

  // Method to convert the Product object to a JSON string
  String toJson() => json.encode(toMap());

  // Factory method to create a Product object from a JSON string
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
