import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UpdateProductPage extends StatefulWidget {
  final Map<String, dynamic> product; // Product data passed from the previous screen

  UpdateProductPage({required this.product});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Uint8List? _imageBytes; // For storing image data

@override
void initState() {
  super.initState();
  print(widget.product);  // Add this to see the product data
  _nameController.text = widget.product['name'] ?? '';
  _descriptionController.text = widget.product['description'] ?? '';
  _priceController.text = widget.product['price']?.toString() ?? '0';
  _stockController.text = widget.product['stock']?.toString() ?? '0';
  _categoryController.text = widget.product['category'] ?? '';
}


  // Function to pick an image
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _imageBytes = result.files.first.bytes; // Get bytes for Web
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick image."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to update the product
 Future<void> _updateProduct() async {
  if (_formKey.currentState!.validate()) {
    // Make sure the product _id is valid
    if (widget.product['_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product ID is missing."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare product data for update
    Map<String, dynamic> updatedProduct = {
      "name": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "price": _priceController.text.trim(),
      "stock": _stockController.text.trim(),
      "category": _categoryController.text.trim(),
    };

    // Create the update request with _id
    var uri = Uri.parse('http://localhost:5000/api/products/${widget.product['_id']}'); // Use _id here
    var request = http.MultipartRequest('PUT', uri);

    // Add updated form fields
    request.fields['name'] = updatedProduct['name'];
    request.fields['description'] = updatedProduct['description'];
    request.fields['price'] = updatedProduct['price'];
    request.fields['stock'] = updatedProduct['stock'];
    request.fields['category'] = updatedProduct['category'];

    // Add the image file if it's updated
    if (_imageBytes != null) {
      var image = http.MultipartFile.fromBytes(
        'image',
        _imageBytes!,
        filename: 'product_image.jpg', // You can choose a dynamic filename if you want
        contentType: MediaType('image', 'jpeg'), // Update content type based on the file format
      );
      request.files.add(image);
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true); // Return to the previous screen and refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update product'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Update Product",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) => value!.isEmpty ? "Please enter product name" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) => value!.isEmpty ? "Please enter product description" : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Please enter product price" : null,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: "Stock"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Please enter product stock" : null,
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: "Category"),
                  validator: (value) => value!.isEmpty ? "Please enter product category" : null,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _imageBytes != null
                        ? Image.memory(
                            _imageBytes!,
                            width: 50,
                            height: 50,
                          )
                        : Text("No Image Selected"),
                    ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Ajuste la taille du bouton à son contenu
                      children: [
                        Icon(Icons.image, color: Colors.white), // Remplace `Icons.image` par l'icône que vous voulez
                        SizedBox(width: 8), // Espacement entre l'icône et le texte
                        Text(
                          "Pick Image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
                SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey, // Couleur de fond pour le bouton Cancel
                          foregroundColor: Colors.white, // Couleur du texte
                        ),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _updateProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Couleur de fond pour le bouton Update
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ajuste la taille du bouton à son contenu
                          children: [
                            Icon(Icons.edit, color: Colors.white), // Icône pour Update
                            SizedBox(width: 8), // Espacement entre l'icône et le texte
                            Text(
                              "Update Product",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
