import 'package:flutter/material.dart';
import 'package:miel_app/models/order.dart';
import 'package:miel_app/services/orderService.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService orderService = OrderService();
  late Future<List<Order>> orders;

  @override
  void initState() {
    super.initState();
    orders = orderService.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder<List<Order>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: orders.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Number: ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text('Status: ${order.status ?? "N/A"}'),
                              const SizedBox(height: 8),
                              Text('Total: \$${order.total?.toStringAsFixed(2) ?? "0.00"}'),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                            onPressed: () {
                              _showOrderDetailsDialog(context, order);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteOrder(order.id ?? '');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${order.id ?? "N/A"}'),
              const SizedBox(height: 10),
              Text('Status: ${order.status ?? "N/A"}'),
              const SizedBox(height: 10),
              Text('Total: \$${order.total?.toStringAsFixed(2) ?? "0.00"}'),
              const SizedBox(height: 10),
              Text('Products:'),
              if (order.products != null && order.products!.isNotEmpty)
                ...order.products!.map((product) {
                  final productName = product['productId']?['name'] ?? 'Unknown';
                  final quantity = product['quantity'] ?? '0';
                  final price = product['productId']?['price']?.toStringAsFixed(2) ?? '0.00';

                  return Text('Product: $productName - Quantity: $quantity - Price: \$$price');
                }).toList()
              else
                const Text('No products available.'),
              const SizedBox(height: 10),
              Text('User Details:'),
              Text('Name: ${order.user?['name'] ?? "Unknown"}'),
              Text('Email: ${order.user?['email'] ?? "Unknown"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(String orderId) {
    if (orderId.isNotEmpty) {
      print('Order deleted: $orderId');
      // Implémenter l'appel API pour supprimer la commande et rafraîchir la liste
    }
  }
}
