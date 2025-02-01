import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double getTotalPrice() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          children: [
            SizedBox(width: 10),
            Text('My Shopping Cart',style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
               SizedBox(width: 10),
                Icon(Icons.shopping_cart,color: Colors.orange.shade200,),

          ],
        ),
            // Cart items list
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  var item = widget.cartItems[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: item['image'] != null
                          ? Image.network(
                              'http://192.168.1.21:5000/${item['image']}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image, size: 50),
                      title: Text(item['name'] ?? 'No name'),
                      subtitle: Text('Price: ${item['price']} TND\nQuantity: ${item['quantity']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          setState(() {
                            widget.cartItems.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Total Price
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${getTotalPrice()} TND',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Checkout Button
            SizedBox(
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
                  // Handle checkout action
                },
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
