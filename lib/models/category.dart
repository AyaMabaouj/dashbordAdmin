class Product {
  final String id;
  final String name;
  final String description;
 

  Product({
    required this.id,
    required this.name,
    required this.description,
   
  });

  // Convert a JSON object into a Product instance
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:json['id'],
      name: json['name'],
      description: json['description'],
      
    );
  }

  // Convert a Product instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'description': description,
    };
  }
}
