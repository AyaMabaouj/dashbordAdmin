import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miel_app/models/order.dart';

class OrderService {
  static const String baseUrl = 'http://localhost:5000/api/orders';

  Future<List<Order>> fetchOrders() async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    // Map the response to a list of Order objects
    return data.map((orderJson) {
      return Order.fromJson(orderJson as Map<String, dynamic>);
    }).toList();
  } else {
    throw Exception('Failed to load orders');
  }
}

}
