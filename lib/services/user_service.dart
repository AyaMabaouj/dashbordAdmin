import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miel_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'http://localhost:5000/api/users'; // Replace with your backend URL
  static const String authUrl = 'http://localhost:5000/auth'; // Auth route for login and register

  // Fetch all users
  static Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  // Create a new user
  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Update an existing user
  static Future<User> updateUser(String id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Delete a user
  static Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
  // Create a new user (Registration)
  static Future<User> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$authUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'address': user.address,
        'number': user.number,
        'role': user.role,
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  // User Login
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$authUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If login is successful, return the response body (which contains the token and user data)
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }


  Future<Map<String, dynamic>> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return user data if successful
      } else {
        throw Exception('User not found');
      }
    } catch (error) {
      throw Exception('Error fetching user: $error');
    }
  }

  // Logout user
  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Retrieve the token

    if (token != null) {
      final response = await http.post(
        Uri.parse('$authUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Send token to be blacklisted
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token'); // Remove token from storage
        await prefs.remove('user'); // Optionally remove user data
      } else {
        throw Exception('Failed to logout: ${response.body}');
      }
    }
  }

}
