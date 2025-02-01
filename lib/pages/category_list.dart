import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miel_app/controllers/CategoryController.dart';
import 'package:miel_app/services/category_service.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories',
              style: TextStyle(color: Colors.white),
),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,  // Enables horizontal scrolling if needed
          child: Card(
            elevation: 5,  // White elevation effect
            color: Colors.white,  // White background for better visibility
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),  // Rounded corners for the card
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                columns: const [
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: controller.categories.map((category) {
                  return DataRow(
                    cells: [
                      DataCell(Text(category['name'])),
                      DataCell(Text(category['description'] ?? 'No description')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showUpdateCategoryDialog(context, category);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, category['_id']);
                            },
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        backgroundColor: Colors.green,  // Green color for FAB
        child: const Icon(Icons.add,color: Colors.white,),
        tooltip: 'Add Category',
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Category Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,  // Grey background for cancel button
                foregroundColor: Colors.white,  // White text color
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final apiService = ApiService();
                  final success = await apiService.addCategory({
                    'name': _nameController.text.trim(),
                    'description': _descriptionController.text.trim(),
                  });

                  if (success) {
                    controller.fetchCategories();
                    Navigator.of(context).pop();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Green background for Add button
                foregroundColor: Colors.white,  // White text color
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateCategoryDialog(BuildContext context, Map<String, dynamic> category) {
    if (category['_id'] == null) {
      print("Error: Category ID is null");
      return;
    }

    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: category['name']);
    final _descriptionController = TextEditingController(text: category['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Category Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Category Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final apiService = ApiService();
                  final success = await apiService.updateCategory(
                    category['_id'],
                    {
                      'name': _nameController.text.trim(),
                      'description': _descriptionController.text.trim(),
                    },
                  );

                  if (success) {
                    controller.fetchCategories();
                    Navigator.of(context).pop();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final apiService = ApiService();
                final success = await apiService.deleteCategory(id);

                if (success) {
                  controller.fetchCategories();
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
