import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:5000/api/categories'; // Replace with your API URL

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<bool> addCategory(Map<String, dynamic> category) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding category: $e');
      return false;
    }
  }

Future<bool> updateCategory(String id, Map<String, dynamic> category) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'), // Make sure the ID is appended to the URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error updating category: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error updating category: $e');
    return false;
  }
}


  Future<bool> deleteCategory(String id) async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/$id')); // Ensure correct URL structure

    if (response.statusCode == 200) { // API should return 200 for success
      return true;
    } else {
      print('Error deleting category: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error deleting category: $e');
    return false;
  }
}
}
