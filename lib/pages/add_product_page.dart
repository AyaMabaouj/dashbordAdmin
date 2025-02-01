import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Uint8List? _imageBytes; // For storing image data

  // Function to pick an image
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
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

  // Function to submit the product
  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      // Create a multipart request
      var uri = Uri.parse('http://localhost:5000/api/products'); // Replace with your backend API URL
          var request = http.MultipartRequest('POST', uri);

          // Add form fields
          request.fields['name'] = _nameController.text.trim();
          request.fields['description'] = _descriptionController.text.trim();
          request.fields['price'] = _priceController.text.trim();
          request.fields['stock'] = _stockController.text.trim();
          request.fields['category'] = _categoryController.text.trim();

          // Add image file if available
          if (_imageBytes != null) {
            var image = http.MultipartFile.fromBytes(
              'image', // This should match the backend field name
              _imageBytes!,
              filename: 'product_image.jpg', // Filename is optional but helps with identification
              contentType: MediaType('image', 'jpeg'), // Image type
            );
            request.files.add(image);
          }

          // Send the request
          try {
            var response = await request.send();
            if (response.statusCode == 201) {
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Product added successfully'),
                backgroundColor: Colors.green,
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to add product'),
                backgroundColor: Colors.red,
              ));
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
                  "Add Product",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter product name" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter product description" : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter product price" : null,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: "Stock"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter product stock" : null,
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: "Category"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter product category" : null,
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
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Couleur de fond pour le bouton Add Product
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ajuste la taille du bouton à son contenu
                        children: [
                          Icon(Icons.add, color: Colors.white), // Icône pour "Add Product"
                          SizedBox(width: 8), // Espacement entre l'icône et le texte
                          Text(
                            "Add Product",
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
