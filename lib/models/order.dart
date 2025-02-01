class Order {
  final String id;
  final List<Map<String, dynamic>> products;
  final Map<String, dynamic> user;  // Changed from List to Map for a single user
  final double total;
  final String status;

  Order({
    required this.id,
    required this.products,
    required this.user,  // Changed from List to Map
    required this.total,
    required this.status,
  });

  // Factory method to create an Order from JSON response
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      products: List<Map<String, dynamic>>.from(json['products'].map((product) {
        return Map<String, dynamic>.from(product);
      })),
      user: Map<String, dynamic>.from(json['user']),  // Changed from list to map
      total: json['total'].toDouble(),
      status: json['status'],
    );
  }
}
