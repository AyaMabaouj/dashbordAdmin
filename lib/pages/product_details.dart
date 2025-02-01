import 'package:flutter/material.dart';
import 'package:miel_app/pages/Cart_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.product['image'] != null
                  ? Image.network(
                      'http://192.168.1.21:5000/${widget.product['image']}',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.image, size: 200),
            ),
            SizedBox(height: 20),
            Text(
              widget.product['name'] ?? 'No name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Price: ${widget.product['price'] ?? 0} TND',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.product['description'] ?? 'No description available',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stock:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.product['stock'] ?? 0}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    // "-" Button
                    GestureDetector(
                      onTap: quantity > 1
                          ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                          : null,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.remove, size: 20,color:Colors.black),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Quantity Display
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    // "+" Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.add, size: 20,color:Colors.black,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Handle adding to cart
                     Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(cartItems: [],),
                              ),
                            );
                  },
                  child: Text('Add to Cart',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
