class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.image,
  });

  // Convert a JSON object into a Product instance
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      category: json['category'],
      image: json['image'] ?? '', // Default value if image is null
    );
  }

  // Convert a Product instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'image': image,
    };
  }
}
