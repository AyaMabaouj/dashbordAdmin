import 'package:flutter/material.dart';
import 'package:miel_app/pages/add_product_page.dart';
import 'package:miel_app/pages/edit_product_page.dart';
import 'package:miel_app/services/product_service.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<dynamic>> products;

  @override
  void initState() {
    super.initState();
    products = ProductService().getProducts();
  }

  // Function to handle product deletion
  Future<void> _deleteProduct(String productId) async {
    bool isDeleted = await ProductService().deleteProduct(productId);
    if (isDeleted) {
      setState(() {
        products = ProductService().getProducts(); // Refresh the product list
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product deleted successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete product'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Show confirmation dialog for deletion
  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey, // Couleur de fond
                foregroundColor: Colors.white, // Couleur du texte
              ),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                _deleteProduct(productId); // Appeler la fonction de suppression
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Couleur de fond (par exemple, rouge pour une action de suppression)
                foregroundColor: Colors.white, // Couleur du texte
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to show update dialog
  void _showUpdateDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateProductPage(product: product); // Popup to update product
      },
    ).then((value) {
      if (value == true) {
        setState(() {
          products = ProductService().getProducts(); // Refresh the product list
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            var productList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddProductPage();
                            },
                          ).then((value) {
                            if (value == true) {
                              setState(() {
                                products = ProductService().getProducts();
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Add Product",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 1, 216, 76),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // Enables horizontal scrolling if needed
                      child: Card(
                        elevation: 5, // White elevation effect
                        color: Colors.white, // White background for better visibility
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded corners for the card
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                            columns: const [
                              DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: productList.map<DataRow>((product) {
                              return DataRow(cells: [
                                DataCell(
                                  product['image'] != null
                                      ? Image.network(
                                          'http://192.168.1.21:5000/${product['image']}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.image, size: 50),
                                ),
                                DataCell(Text(product['name'] ?? '', 
                                             overflow: TextOverflow.visible,
                                    )),
                                DataCell(
                                  Text(
                                    product['description'] ?? 'No description',
                                    maxLines: 2, // Limite le texte à 2 lignes
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true, // Ajoute des points de suspension si le texte dépasse
                                  ),
                                ),
                                DataCell(Text('${product['price'] ?? 0} TND')),
                                DataCell(Text('${product['stock'] ?? 0}')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          _showUpdateDialog(product);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          var productId = product['_id'];
                                          if (productId != null) {
                                            _showDeleteConfirmationDialog(productId);
                                          } else {
                                            print('Product ID is null');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}