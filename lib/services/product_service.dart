import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl = 'http://192.168.1.21:5000/api/products';  // Update with your backend URL

  // Fetch all products
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<bool> addProduct(Map<String, dynamic> product) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product), // Sending data as JSON
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }
  // Update product
  Future<bool> updateProduct(String id, Map<String, dynamic> product) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
}
