import 'dart:convert';

import 'package:get/get.dart';
import 'package:miel_app/services/category_service.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController {
  var categories = [].obs;
  var isLoading = true.obs;
  final String baseUrl = 'http://localhost:5000/api/categories'; // Remplacez par l'URL de votre API

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      var fetchedCategories = await _apiService.fetchCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    } finally {
      isLoading(false);
    }
  }
  void addCategory(String name, String? description) async {

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'description': description}),
    );

    if (response.statusCode == 201) {
      fetchCategories(); // Rafraîchir la liste après ajout
      Get.snackbar('Success', 'Category added successfully');
    } else {
      Get.snackbar('Error', 'Failed to add category: ${response.body}');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to add category');
  }
}

}
